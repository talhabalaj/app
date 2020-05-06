import 'dart:collection';

import 'package:app/helpers/authed_request.dart';
import 'package:app/models/api_response_model.dart';
import 'package:app/models/create_post_model.dart';
import 'package:app/models/error_response_model.dart';
import 'package:app/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:http_parser/http_parser.dart';
import 'package:app/models/post_model.dart';

class PostService extends ChangeNotifier {
  AuthService authService;
  Queue<CreatePostModel> postQueue = new Queue<CreatePostModel>();

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

  Future<PostModel> createPost(CreatePostModel newPost) async {
    FormData formData = new FormData.fromMap({
      "caption": newPost.caption,
      "image": MultipartFile.fromBytes(
        newPost.image,
        filename: 'image.jpg',
        contentType: MediaType.parse('image/jpeg'),
      ),
    });

    Response<dynamic> res;
    postQueue.addFirst(newPost);
    notifyListeners();

    try {
      res = await AuthenticatedRequest(authService: this.authService)
          .request
          .post(
            '/post/create',
            data: formData,
          );
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        res = e.response;
      } else {
        throw e;
      }
    }

    if (res.statusCode == 200) {
      postQueue.remove(newPost);
      notifyListeners();

      return WebApiSuccessResponse<PostModel>.fromJson(res.data).data;
    } else {
      throw WebApiErrorResponse.fromJson(res.data);
    }
  }
}
