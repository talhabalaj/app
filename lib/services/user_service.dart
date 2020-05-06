import 'package:app/helpers/authed_request.dart';
import 'package:app/models/api_response_model.dart';
import 'package:app/models/error_response_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class UserService extends ChangeNotifier {
  AuthService authService;

  UserService({this.authService});

  Future<UserModel> getUserProfile(String userName) async {
    Response<dynamic> res;

    try {
      res = await AuthenticatedRequest(authService: authService).request.get(
            '/user/profile/$userName',
          );
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        res = e.response;
      } else {
        throw e;
      }
    }

    if (res.statusCode == 200) {
      final body = WebApiSuccessResponse<UserModel>.fromJson(res.data).data;
      return body;
    } else {
      throw WebApiErrorResponse.fromJson(res.data);
    }
  }
}
