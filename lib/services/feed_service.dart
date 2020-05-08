import 'dart:developer';

import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/models/api_response_model.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/models/feed_model.dart';
import 'package:Moody/models/post_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/widgets.dart';

class FeedService extends ChangeNotifier {
  FeedModel _feed;
  bool loading = true;
  AuthService authService;

  FeedModel get feed => _feed;

  Future<Response<dynamic>> requestFeed(
      {int offset = 0, int limit = 10}) async {
    Response<dynamic> res;

    if (loading) {
      loading = true;
      notifyListeners();
    }

    try {
      res = await AuthenticatedRequest(authService: this.authService)
          .request
          .get('/feed?offset=$offset&limit=$limit');
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        res = e.response;
      } else {
        throw e;
      }
    }

    loading = false;
    notifyListeners();

    return res;
  }

  Future<void> initFeed() async {
    Response<dynamic> res = await requestFeed();

    if (res != null) {
      if (res.statusCode == 200) {
        _feed = WebApiSuccessResponse<FeedModel>.fromJson(res.data).data;
        notifyListeners();
      } else {
        throw WebApiErrorResponse.fromJson(res.data);
      }
    }
  }

  Future<void> refreshFeed() async {
    Response<dynamic> res = await requestFeed(limit: 20);

    if (res != null) {
      if (res.statusCode == 200) {
        FeedModel lastestFeed =
            WebApiSuccessResponse<FeedModel>.fromJson(res.data).data;
        _feed = lastestFeed;
        notifyListeners();
      } else {
        throw WebApiErrorResponse.fromJson(res.data);
      }
    }
  }

  Future<void> getOldPost() async {
    Response<dynamic> res = await requestFeed(offset: _feed.posts.length);

    if (res != null) {
      if (res.statusCode == 200) {
        FeedModel oldFeed =
            WebApiSuccessResponse<FeedModel>.fromJson(res.data).data;
        _feed.posts.addAll(oldFeed.posts);
        notifyListeners();
      } else {
        throw WebApiErrorResponse.fromJson(res.data);
      }
    }
  }

  FeedService update(AuthService authService) {
    this.authService = authService;
    print(
        '[FeedService] updated! ${authService.user != null ? authService.user.userName : ''}');
    if (authService.user == null)
      _feed = null;
    else if (_feed == null) initFeed();

    return this;
  }

  Future<void> createPost(PostModel newPost) async {
    FormData formData = new FormData.fromMap({
      "caption": newPost.caption,
      "image": MultipartFile.fromBytes(
        newPost.image,
        filename: 'image.jpg',
        contentType: MediaType.parse('image/jpeg'),
      ),
    });

    Response<dynamic> res;
    feed.posts.insert(0, newPost);
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
      int index = feed.posts.indexWhere((post) => post.sId == newPost.sId);
      feed.posts[index] =
          WebApiSuccessResponse<PostModel>.fromJson(res.data).data;
      notifyListeners();
    } else {
      throw WebApiErrorResponse.fromJson(res.data);
    }
  }

  @override
  void dispose() {
    log("Disposed FeedService");
    super.dispose();
  }
}
