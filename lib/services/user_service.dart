import 'dart:developer';

import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/models/api_response_model.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/models/post_model.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/services/auth_service.dart';
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

  Future<List<PostModel>> getUserPosts(
      {String userName, int offset = 0}) async {
    Response<dynamic> res;

    try {
      res = await AuthenticatedRequest(authService: authService).request.get(
            '/user/posts/${userName == null ? '' : userName}?offset=$offset',
          );
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        res = e.response;
      } else {
        throw e;
      }
    }

    if (res.statusCode == 200) {
      return WebApiSuccessResponse<List<PostModel>>.fromJson(res.data).data;
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
        notifyListeners();
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
