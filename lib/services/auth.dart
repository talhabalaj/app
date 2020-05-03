import 'dart:convert';
import 'package:app/constants.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/authtoken.dart';
import 'package:app/models/error_response.dart';
import 'package:app/models/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthServiceError extends Error {
  final String message;

  AuthServiceError(this.message);
}

class AuthService {
  AuthToken auth;

  Future<void> login(String userName, String password) async {
    http.Response res;

    res = await http.post(
      '${kApiUrl}user/login',
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
        final WebApiSuccessResponse<User> body =
            WebApiSuccessResponse.fromJson(jsonDecode(res.body));

        final token = res.headers["set-cookie"].split(";")[0].split("=")[1];
        final secureStorage = FlutterSecureStorage();
        secureStorage.write(key: 'token', value: token);

        auth = AuthToken(
          token: token,
        );
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
      '${kApiUrl}user/register',
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

    final res = await http.get('${kApiUrl}user/logout', headers: {
      "Cookie": "access_token=${auth.token}",
    });

    if (res.statusCode == 200) {
      auth = null;
    } else {
      throw WebApiErrorResponse.fromJson(jsonDecode(res.body));
    }
  }

  Future<void> load() async {
    final secureStorage = FlutterSecureStorage();
    final data = await secureStorage.readAll();
    if (data['token'] != null) {
      auth = AuthToken(token: data['token']);
    } else {
      throw AuthServiceError("Not logged in");
    }
  }
}
