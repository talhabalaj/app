import 'package:app/models/feed_model.dart';
import 'package:app/models/user_model.dart';
import 'package:flutter/widgets.dart';

class WebApiSuccessResponse<T> {
  String message;
  int status;
  T data;

  WebApiSuccessResponse.withData(
      {@required this.status, @required this.message, this.data});

  WebApiSuccessResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (T == UserModel) {
      data = UserModel.fromJson(json['data']['user']) as T;
    } else if (T == FeedModel) {
      data = FeedModel.fromJson(json['data']['posts']) as T;
    } else if (T == Map) {
      data = json['data'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
