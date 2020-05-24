import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:Moody/constants.dart';
import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/models/api_response_model.dart';
import 'package:Moody/models/authtoken_model.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/services/fcm_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthServiceError extends Error {
  final String message;

  AuthServiceError(this.message);
}

class AuthService extends ChangeNotifier {
  AuthTokenModel auth;
  UserModel user;
  FCM fcm = FCM();

  final secureStorage = FlutterSecureStorage();

  Future<void> refreshUser() async {
    assert(auth != null, "[refreshUser] requires auth");

    user = (await ApiRequest(authService: this)
            .request<UserModel>('/user/profile'))
        .data;

    final timer = Timer(Duration(seconds: 10), () {
      print("Updating user!");
      refreshUser();
    });

    notifyListeners();
  }

  Future<void> login(String userName, String password) async {
    http.Response res;

    res = await http.post(
      '$kApiUrl/user/login',
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "userName": userName,
        "password": password,
      }),
    );

    if (res != null) {
      if (res.statusCode == 202) {
        final WebResponse<Map> body =
            WebResponse.fromJson(jsonDecode(res.body));

        final token = body.data['tokenInfo']['token'] as String;
        final expiresAt = body.data['tokenInfo']['expiresAt'] as String;
        final secureStorage = FlutterSecureStorage();
        secureStorage.write(key: 'token', value: token);
        secureStorage.write(key: 'expiresAt', value: expiresAt);

        auth = AuthTokenModel(
          token: token,
          expiresAt: DateTime.parse(expiresAt),
        );

        await refreshUser();
        // TODO: find a secure way
        fcm.subscribeToNotifications(user.sId);

        notifyListeners();
      } else {
        throw WebErrorResponse.fromJson(jsonDecode(res.body));
      }
    }
  }

  Future<void> register(
      {String userName,
      String password,
      String firstName,
      String lastName,
      String email}) async {
    final res = await http.post(
      '$kApiUrl/user/register',
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "userName": userName,
        "password": password,
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
      }),
    );

    await login(userName, password);
  }

  Future<void> logout() async {
    assert(auth != null, "[logout] requires auth");

    try {
      await ApiRequest(authService: this).request('/user/logout');
    } catch (e) {
      print("Logout was't preformed on server side.");
    }

    auth = null;
    user = null;

    fcm.unsubscribe();
    notifyListeners();
    await secureStorage.delete(key: 'token');
  }

  Future<void> load() async {
    final data = await secureStorage.readAll();
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
  }

  Future<void> refresh() {
    // TODO: implement
  }

  @override
  void dispose() {
    log('The Authservice has been disposed');
    super.dispose();
  }
}
