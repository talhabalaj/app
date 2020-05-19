import 'package:Moody/models/user_model.dart';

class CommentModel {
  List<CommentModel> replies;
  String replyOf;
  String sId;
  UserModel user;
  String userId;
  String post;
  String message;
  String createdAt;
  String updatedAt;
  bool isProcessing;

  CommentModel(
      {this.replies,
      this.replyOf,
      this.sId,
      this.user,
      this.post,
      this.message,
      this.createdAt,
      this.updatedAt,
      this.isProcessing});

  CommentModel.fromJson(Map<String, dynamic> json) {
    if (json['replies'] != null) {
      replies = new List<Null>();
      json['replies'].forEach((v) {
        replies.add(new CommentModel.fromJson(v));
      });
    }
    replyOf = json['replyOf'];
    sId = json['_id'];
    if (json['user'] is String) {
      userId = json['user'];
    } else {
      user = UserModel.fromJson(json['user']);
      userId = user.sId;
    }
    post = json['post'];
    message = json['message'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    isProcessing = false;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.replies != null) {
      data['replies'] = this.replies.map((v) => v.toJson()).toList();
    }
    data['replyOf'] = this.replyOf;
    data['_id'] = this.sId;
    data['user'] = this.user;
    data['post'] = this.post;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
