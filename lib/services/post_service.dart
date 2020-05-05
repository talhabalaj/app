import 'package:app/helpers/authed_request.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/widgets.dart';
import 'package:app/models/post_model.dart';

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
    this.authService = authService;
    return this;
  }
}
