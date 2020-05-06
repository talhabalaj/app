import 'dart:developer';

import 'package:app/helpers/authed_request.dart';
import 'package:app/models/api_response_model.dart';
import 'package:app/models/error_response_model.dart';
import 'package:app/models/feed_model.dart';
import 'package:app/services/auth_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';

class FeedService extends ChangeNotifier {
  FeedModel _feed;
  AuthService authService;
  FeedService({this.authService}) : _feed = FeedModel();

  FeedModel get feed => _feed;

  Future<Response<dynamic>> requestFeed({int offset = 0}) async {
    Response<dynamic> res;

    try {
      res = await AuthenticatedRequest(authService: this.authService)
          .request
          .get('/feed?offset=$offset');
    } on DioError catch (e) {
      if (e.type == DioErrorType.RESPONSE) {
        res = e.response;
      } else {
        throw e;
      }
    }

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
    Response<dynamic> res = await requestFeed();

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
    return this;
  }

  @override
  void dispose() {
    log("Disposed FeedService");
    super.dispose();
  }
}
