import 'dart:developer';

import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:Moody/models/post_model.dart';

class PostService extends ChangeNotifier {
  AuthService authService;

  PostService({this.authService});

  Future<void> like(PostModel post) async {
    if (post.likes.indexOf(authService.user.sId) == -1) {
      post.likes.add(authService.user.sId);
      notifyListeners();
      try {
        await AuthenticatedRequest(authService: authService)
            .request
            .get('/post/${post.sId}/like');
      } catch (e) {
        post.likes.remove(authService.user);
        notifyListeners();
      }
    }
  }

  Future<void> unlike(PostModel post) async {
    if (post.likes.indexOf(authService.user.sId) != -1) {
      post.likes.remove(authService.user.sId);
      notifyListeners();
      try {
        await AuthenticatedRequest(authService: authService)
            .request
            .get('/post/${post.sId}/unlike');
      } catch (e) {
        post.likes.add(authService.user.sId);
        notifyListeners();
      }
    }
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
