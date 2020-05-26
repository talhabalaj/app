import 'package:Moody/models/message_model.dart';
import 'package:Moody/models/user_model.dart';

class ConversationModel {
  List<UserModel> members;
  List<MessageModel> messages;
  String sId;
  String createdAt;
  String updatedAt;

  ConversationModel({this.members, this.sId, this.createdAt, this.updatedAt});

  ConversationModel.fromJson(Map<String, dynamic> json) {
    if (json['members'] != null) {
      members = new List<UserModel>();
      try {
        json['members'].forEach((v) {
          members.add(UserModel.fromJson(v));
        });
      } on TypeError catch (e) {
        print('[ConversationModel] memebers were not populated');
      }
    }
    if (json['messages'] != null) {
      messages = new List<MessageModel>();
      try {
        json['messages'].forEach((v) {
          messages.add(MessageModel.fromJson(v));
        });
      } on TypeError catch (e) {
        print('[ConversationModel] messages were not populated');
      }
    }
    sId = json['_id'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.members != null) {
      data['members'] = this.members.map((v) => v.toJson()).toList();
    }
    if (this.messages != null) {
      data['messages'] = this.messages.map((v) => v.toJson()).toList();
    }
    data['_id'] = this.sId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
