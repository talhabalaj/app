import 'dart:developer';

import 'package:app/helpers/authed_request.dart';
import 'package:app/models/api_response_model.dart';
import 'package:app/models/error_response_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

enum UserFollowAction { FOLLOW, UNFOLLOW }

class UserService extends ChangeNotifier {
  AuthService authService;

  UserService();

  UserService update(AuthService authService) {
    print(
        '[UserService] updated! ${authService.user != null ? authService.user.userName : ''}');
    this.authService = authService;
    return this;
  }

  UserModel get loggedInUser => authService.user;

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

  Future<void> changeFollowState(UserModel user,
      {UserFollowAction action = UserFollowAction.FOLLOW}) async {
    Response<dynamic> res;

    String actionString = 'follow';
    if (action == UserFollowAction.UNFOLLOW) actionString = 'unfollow';

    try {
      res = await AuthenticatedRequest(authService: authService).request.get(
            '/user/profile/${user.userName}/$actionString',
          );
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        res = e.response;
      } else {
        throw e;
      }
    }

    if (res.statusCode == 200) {
      final body = WebApiSuccessResponse<Map>.fromJson(res.data).data;
      if (body['modified'] as bool) {
        if (action == UserFollowAction.FOLLOW) {
          authService.user.following.add(user);
          print('added');
        } else {
          authService.user.following.removeWhere((u) => u.sId == user.sId);
          print('removed');
        }
      }
    } else {
      throw WebApiErrorResponse.fromJson(res.data);
    }
  }

  @override
  void dispose() {
    log('The user_service has been disposed');
    super.dispose();
  }
}
