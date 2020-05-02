import 'package:app/models/user.dart';
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
    if (T == User) {
      data = User.fromJson(json['data']['user']) as T;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    return data;
  }
}
