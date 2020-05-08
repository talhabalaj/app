import 'package:Moody/models/feed_model.dart';
import 'package:Moody/models/post_model.dart';
import 'package:Moody/models/user_model.dart';
import 'package:flutter/widgets.dart';

bool isSubtype<T1, T2>() => <T1>[] is List<T2>;

class WebApiSuccessResponse<T> {
  String message;
  int status;
  T data;

  WebApiSuccessResponse.withData(
      {@required this.status, @required this.message, this.data});

  WebApiSuccessResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      if (T == UserModel) {
        data = UserModel.fromJson(json['data']['user']) as T;
      } else if (T == FeedModel) {
        data = FeedModel.fromJson(json['data']['posts']) as T;
      } else if (T == PostModel) {
        data = PostModel.fromJson(json['data']['post']) as T;
      } else if (T == Map) {
        data = json['data'];
      } else if (isSubtype<T, List<UserModel>>()) {
        data = new List<UserModel>() as T;
        var list = data as List;
        if (json['data']['users'] != null) {
          json['data']['users'].forEach((v) => list.add(UserModel.fromJson(v)));
        }
      } else if (isSubtype<T, List<PostModel>>()) {
        data = new List<PostModel>() as T;
        var list = data as List;
        if (json['data']['posts'] != null) {
          json['data']['posts'].forEach((v) => list.add(PostModel.fromJson(v)));
        }
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
