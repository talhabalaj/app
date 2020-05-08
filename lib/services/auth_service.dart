import 'dart:convert';
import 'dart:developer';
import 'package:app/constants.dart';
import 'package:app/helpers/authed_request.dart';
import 'package:app/models/api_response_model.dart';
import 'package:app/models/authtoken_model.dart';
import 'package:app/models/error_response_model.dart';
import 'package:app/models/user_model.dart';
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

  final secureStorage = FlutterSecureStorage();

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
        final WebApiSuccessResponse<Map> body =
            WebApiSuccessResponse.fromJson(jsonDecode(res.body));

        final token = res.headers["set-cookie"].split(";")[0].split("=")[1];
        final expiresAt = body.data['tokenInfo']['expiresAt'] as String;
        final secureStorage = FlutterSecureStorage();
        secureStorage.write(key: 'token', value: token);
        secureStorage.write(key: 'expiresAt', value: expiresAt);

        auth = AuthTokenModel(
          token: token,
          expiresAt: DateTime.parse(expiresAt),
        );

        final resUser = WebApiSuccessResponse<UserModel>.fromJson(
          (await AuthenticatedRequest(authService: this)
                  .request
                  .get('/user/profile'))
              .data,
        );
        user = resUser.data;
        notifyListeners();
      } else {
        throw WebApiErrorResponse.fromJson(jsonDecode(res.body));
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

    if (res.statusCode == 201) {
      login(userName, password);
    } else {
      throw WebApiErrorResponse.fromJson(jsonDecode(res.body));
    }
  }

  Future<void> logout() async {
    if (auth == null) {
      throw "Oh fuck!";
    }

    try {
      await AuthenticatedRequest(authService: this).request.get('/user/logout');
    } catch (e) {
      print("Logout was't preformed on server side.");
    }

    auth = null;
    user = null;
    notifyListeners();
    await secureStorage.delete(key: 'token');
  }

  Future<void> load() async {
    final data = await secureStorage.readAll();
    if (data['token'] != null) {
      auth = AuthTokenModel(
          token: data['token'], expiresAt: DateTime.parse(data['expiresAt']));
      final res = WebApiSuccessResponse<UserModel>.fromJson(
        (await AuthenticatedRequest(authService: this)
                .request
                .get('/user/profile'))
            .data,
      );
      user = res.data;
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
