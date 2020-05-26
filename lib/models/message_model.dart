import 'package:Moody/helpers/random.dart';
import 'package:Moody/models/user_model.dart';

class MessageModel {
  bool delivered;
  bool seen;
  String sId;
  UserModel from;
  String content;
  String conversation;
  String createdAt;
  bool sent;
  String updatedAt;

  MessageModel({
    this.delivered = false,
    this.sent = false,
    this.seen = false,
    String sId,
    this.from,
    this.content,
    this.conversation,
  }) : this.sId = sId != null ? sId : RandomString.createCryptoRandomString() {
    String currentTime = DateTime.now().toIso8601String();
    this.createdAt = currentTime;
    this.updatedAt = currentTime;
  }

  MessageModel.fromJson(Map<String, dynamic> json) {
    delivered = json['delivered'];
    seen = json['seen'];
    sId = json['_id'];
    from = UserModel.fromJson(json['from']);
    content = json['content'];
    conversation = json['conversation'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    sent = true;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['delivered'] = this.delivered;
    data['seen'] = this.seen;
    data['_id'] = this.sId;
    data['from'] = this.from.toJson();
    data['content'] = this.content;
    data['conversation'] = this.conversation;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
