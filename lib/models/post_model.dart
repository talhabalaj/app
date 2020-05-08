import 'package:app/helpers/random.dart';
import 'package:app/models/comment_model.dart';
import 'package:app/models/user_model.dart';

enum PostStateType { MEMORY, NETWORK }

class PostModel {
  String caption;
  List<String> likes;
  List<CommentModel> comments;
  String sId;
  String imageUrl;
  UserModel user;
  String createdAt;
  String updatedAt;
  PostStateType stateType;
  List<int> image;

  PostModel.inMemory({this.caption, this.image, this.user}) {
    if (this.image != null) {
      stateType = PostStateType.MEMORY;
      likes = [];
      comments = [];
      sId = RandomString.createCryptoRandomString();
    }
  }

  PostModel.fromJson(Map<String, dynamic> json) {
    stateType = PostStateType.NETWORK;
    caption = json['caption'];
    if (json['likes'] != null) {
      likes = new List<String>();
      json['likes'].forEach((v) {
        likes.add(v);
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
      data['likes'] = this.likes;
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
