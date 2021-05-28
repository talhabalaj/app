import 'dart:async';
import 'dart:developer';

import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/models/api_response_model.dart';
import 'package:Moody/models/authtoken_model.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/services/fcm_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart'
    show FlutterSecureStorage;

class AuthServiceError extends Error {
  final String message;

  AuthServiceError(this.message);
}

class AuthService extends ChangeNotifier {
  AuthTokenModel auth;
  UserModel user;
  Timer userRefresher;
  FCM fcm = FCM();

  final secureStorage = FlutterSecureStorage();

  Future<void> refreshUser() async {
    assert(auth != null || kIsWeb, "[refreshUser] requires auth on !web");

    user = (await ApiRequest(authService: this)
            .request<UserModel>('/user/profile'))
        .data;

    userRefresher = Timer(Duration(seconds: 10), () {
      print("Updating user!");
      refreshUser();
    });

    notifyListeners();
  }

  Future<void> login(String userName, String password) async {
    var res = await Dio().post('$apiUrl/user/login',
        data: ({
          "userName": userName,
          "password": password,
        }),
        options: Options(extra: {'withCredentials': true}));

    if (res != null) {
      if (res.statusCode == 202) {
        final WebResponse<Map> body = WebResponse.fromJson(res.data);

        final token = body.data['tokenInfo']['token'] as String;
        final expiresAt = body.data['tokenInfo']['expiresAt'] as String;

        if (!kIsWeb) {
          final secureStorage = FlutterSecureStorage();
          secureStorage.write(key: 'token', value: token);
          secureStorage.write(key: 'expiresAt', value: expiresAt);
        }

        auth = AuthTokenModel(
          token: token,
          expiresAt: DateTime.parse(expiresAt),
        );

        await refreshUser();
        // TODO: find a secure way
        fcm.subscribeToNotifications(user.sId);

        notifyListeners();
      } else {
        throw WebErrorResponse.fromJson(res.data);
      }
    }
  }

  Future<void> register({
    String userName,
    String password,
    String firstName,
    String lastName,
    String email,
  }) async {
    await Dio().post(
      '$apiUrl/user/register',
      data: ({
        "userName": userName,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
      }),
      options: Options(
        extra: {
          'withCredentials': true,
        },
      ),
    );

    await login(userName, password);
  }

  Future<void> logout() async {
    assert(kIsWeb || auth != null, "[logout] requires auth");

    try {
      await ApiRequest(authService: this).request('/user/logout');
    } catch (e) {
      print("Logout was't preformed on server side.");
    }

    auth = null;
    user = null;
    fcm.unsubscribe();
    userRefresher.cancel();

    notifyListeners();
    if (!kIsWeb) await secureStorage.delete(key: 'token');
  }

  Future<void> load() async {
    Map<String, String> data;

    if (!kIsWeb) {
      data = await secureStorage.readAll();
      if (data['token'] != null) {
        auth = AuthTokenModel(
          token: data['token'],
          expiresAt: DateTime.parse(
            data['expiresAt'],
          ),
        );

        await refreshUser();
      } else {
        throw AuthServiceError("Not logged in");
      }
    } else {
      await refreshUser();
    }
  }

  @override
  void dispose() {
    log('The Authservice has been disposed');
    super.dispose();
  }
}
