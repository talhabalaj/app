import 'dart:developer';

import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/helpers/random.dart';
import 'package:Moody/models/api_response_model.dart';
import 'package:Moody/models/comment_model.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:Moody/models/post_model.dart';
import 'package:toast/toast.dart';

class PostService extends ChangeNotifier {
  AuthService authService;

  PostService({this.authService});

  Future<void> like(PostModel post) async {
    if (post.likes.indexOf(authService.user.sId) == -1) {
      post.likes.add(authService.user.sId);
      notifyListeners();
      try {
        await ApiRequest(authService: authService)
            .request('/post/${post.sId}/like', method: HttpRequestMethod.GET);
      } catch (e) {
        post.likes.remove(authService.user);
        notifyListeners();
      }
    }
  }

  Future<PostModel> getPost(String sId) async {
    return (await ApiRequest(authService: authService).request<PostModel>(
      '/post/$sId',
      method: HttpRequestMethod.GET,
    ))
        .data;
  }

  Future<void> unlike(PostModel post) async {
    if (post.likes.indexOf(authService.user.sId) != -1) {
      post.likes.remove(authService.user.sId);
      notifyListeners();
      try {
        await ApiRequest(authService: authService)
            .request('/post/${post.sId}/unlike', method: HttpRequestMethod.GET);
      } catch (e) {
        post.likes.add(authService.user.sId);
        notifyListeners();
      }
    }
  }

  Future<WebResponse<CommentModel>> comment(
      PostModel post, String comment) async {
    final formData = {"message": comment};
    return ApiRequest(authService: authService).request<CommentModel>(
        '/post/${post.sId}/comment',
        method: HttpRequestMethod.POST,
        data: formData);
  }

  Future<WebResponse<CommentModel>> deleteComment(
      PostModel post, String comment) async {
    final formData = {"message": comment};
    return ApiRequest(authService: authService).request<CommentModel>(
        '/post/${post.sId}/comment',
        method: HttpRequestMethod.POST,
        data: formData);
  }

  PostService update(AuthService authService) {
    print(
        '[PostService] updated! ${authService.user != null ? authService.user.userName : ''}');
    this.authService = authService;
    return this;
  }

  @override
  void dispose() {
    log('The post_service has been disposed');
    super.dispose();
  }
}
