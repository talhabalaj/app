import 'dart:developer';

import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/models/post_model.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/services/auth_service.dart';
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

  Future<UserModel> getUserProfile(String id) async {
    final response =
        await ApiRequest(authService: authService).request<UserModel>(
      '/user/profile/$id',
    );

    return response.data;
  }

  Future<List<PostModel>> getUserPosts({String id, int offset = 0}) async {
    final res =
        await ApiRequest(authService: authService).request<List<PostModel>>(
      '/user/${id == null ? '' : '$id/'}posts?offset=$offset',
    );

    return res.data;
  }

  Future<void> changeFollowState(UserModel user,
      {UserFollowAction action = UserFollowAction.FOLLOW}) async {
    String actionString = 'follow';
    if (action == UserFollowAction.UNFOLLOW) actionString = 'unfollow';

    final res = await ApiRequest(authService: authService).request<Map>(
      '/user/profile/${user.sId}/$actionString',
    );

    final body = res.data;

    if (body['modified'] as bool) {
      if (action == UserFollowAction.FOLLOW) {
        authService.user.following.add(user);
      } else {
        authService.user.following.removeWhere((u) => u.sId == user.sId);
      }
      notifyListeners();
    }
  }

  @override
  void dispose() {
    log('The user_service has been disposed');
    super.dispose();
  }
}
