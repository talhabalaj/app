import 'dart:convert';
import 'dart:developer';

import 'package:app/constants.dart';
import 'package:app/models/api_response.dart';
import 'package:app/models/authtoken.dart';
import 'package:app/models/error_response.dart';
import 'package:app/models/user.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
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
        final user = body.data;

        auth = AuthToken(
          user: user,
          token: token,
          isValid: true,
        );

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
}
