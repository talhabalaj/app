import 'package:Moody/models/post_model.dart';
import 'package:Moody/models/user_model.dart';

import 'comment_model.dart';

enum UserNotificationType { POST_LIKED, POST_COMMENTED, USER_FOLLOWED, UNKNOWN }

Map<int, UserNotificationType> notificationMap = {
  0: UserNotificationType.POST_LIKED,
  1: UserNotificationType.POST_COMMENTED,
  2: UserNotificationType.USER_FOLLOWED,
};

class MNotification {
  bool read;
  String sId;
  UserModel from;
  UserModel forUser;
  UserNotificationType type;
  PostModel post;
  CommentModel comment;
  String createdAt;
  String updatedAt;

  MNotification(
      {this.read,
      this.sId,
      this.from,
      this.forUser,
      this.type,
      this.createdAt,
      this.updatedAt});

  MNotification.fromJson(Map<String, dynamic> json) {
    read = json['read'];
    sId = json['_id'];

    from = UserModel.fromJson(json['from']);
    forUser = UserModel.fromJson(json['for']);

    final int typeInt = json['type'];
    if (notificationMap.containsKey(typeInt)) {
      type = notificationMap[typeInt];
    } else {
      type = UserNotificationType.UNKNOWN;
    }

    if (json['comment'] != null) {
      comment = CommentModel.fromJson(json['comment']);
    }

    if (json['post'] != null) {
      post = PostModel.fromJson(json['post']);
    }

    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['read'] = this.read;
    data['_id'] = this.sId;
    data['from'] = this.from.toJson();
    data['for'] = this.forUser.toJson();
    data['type'] = this.type.index;
    data['post'] = this.post != null ? this.post.toJson() : null;
    data['comment'] = this.comment != null ? this.comment.toJson() : null;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
