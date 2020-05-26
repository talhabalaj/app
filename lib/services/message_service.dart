import 'package:Moody/helpers/authed_request.dart';
import 'package:Moody/models/conversation_model.dart';
import 'package:Moody/models/message_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:flutter/foundation.dart';

class MessageService extends ChangeNotifier {
  AuthService authService;
  List<ConversationModel> conversations;
  bool loading = false;

  MessageService update(AuthService authService) {
    this.authService = authService;

    if (this.authService.user == null) {
      conversations = null;
    } else {
      refreshConversations();
    }

    return this;
  }

  Future<void> refreshConversations() async {
    loading = true;
    notifyListeners();

    conversations = (await ApiRequest(authService: authService)
            .request<List<ConversationModel>>('/messages/all'))
        .data;

    loading = false;
    notifyListeners();
  }

  Future<List<MessageModel>> getMessages(String conversationId,
      {int offset = 0}) async {
    return (await ApiRequest(authService: authService)
            .request<List<MessageModel>>(
                '/messages/$conversationId?offset=$offset'))
        .data;
  }

  Future<ConversationModel> createConversation(String userId) async {
    return (await ApiRequest(authService: authService)
            .request<ConversationModel>('/messages/init/$userId'))
        .data;
  }
}
