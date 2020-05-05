import 'package:app/helpers/authed_request.dart';
import 'package:app/models/comment_model.dart';
import 'package:app/models/user_model.dart';

class PostModel {
  String caption;
  List<UserModel> likes;
  List<CommentModel> comments;
  String sId;
  String imageUrl;
  UserModel user;
  String createdAt;
  String updatedAt;

  PostModel(
      {this.caption,
      this.likes,
      this.comments,
      this.sId,
      this.imageUrl,
      this.user,
      this.createdAt,
      this.updatedAt});

  PostModel.fromJson(Map<String, dynamic> json) {
    caption = json['caption'];
    if (json['likes'] != null) {
      likes = new List<UserModel>();
      json['likes'].forEach((v) {
        likes.add(new UserModel.fromJson(v));
      });
    }
    if (json['comments'] != null) {
      comments = new List<CommentModel>();
      json['comments'].forEach((v) {
        comments.add(new CommentModel.fromJson(v));
      });
    }
    sId = json['_id'];
    imageUrl = json['imageUrl'];
    user = UserModel.fromJson(json['user']);
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['caption'] = this.caption;
    if (this.likes != null) {
      data['likes'] = this.likes.map((v) => v.toJson()).toList();
    }
    if (this.comments != null) {
      data['comments'] = this.comments.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['imageUrl'] = this.imageUrl;
    data['user'] = this.user;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
