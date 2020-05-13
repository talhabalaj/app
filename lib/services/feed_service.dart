import 'dart:developer';

import 'package:Moody/helpers/authed_request.dart';
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

  Future<FeedModel> requestFeed({int offset = 0, int limit = 10}) async {
    if (loading) {
      loading = true;
      notifyListeners();
    }

    final res = await ApiRequest(authService: this.authService)
        .request<FeedModel>('/feed?offset=$offset&limit=$limit');

    loading = false;
    notifyListeners();

    return res.data;
  }

  Future<void> initFeed() async {
    _feed = await requestFeed();
    notifyListeners();
  }

  Future<void> refreshFeed() async {
    _feed = await requestFeed(limit: 20);
    notifyListeners();
  }

  Future<void> getOldPost() async {
    _feed.posts.addAll((await requestFeed(offset: _feed.posts.length)).posts);
    notifyListeners();
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

  Future<void> deletePost(PostModel post) async {
    await ApiRequest(authService: this.authService)
        .request('/post/${post.sId}', method: HttpRequestMethod.DELETE);

    feed.posts.removeWhere((p) => p.sId == post.sId);
    notifyListeners();
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

    feed.posts.insert(0, newPost);
    notifyListeners();

    final res =
        await ApiRequest(authService: this.authService).request<PostModel>(
      '/post/create',
      method: HttpRequestMethod.POST,
      data: formData,
    );

    int index = feed.posts.indexWhere((post) => post.sId == newPost.sId);
    feed.posts[index] = res.data;

    notifyListeners();
  }

  @override
  void dispose() {
    log("Disposed FeedService");
    super.dispose();
  }
}
