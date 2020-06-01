import 'dart:convert';

import 'package:Moody/components/bottom_form_text_field.dart';
import 'package:Moody/components/loader.dart';
import 'package:Moody/constants.dart';
import 'package:Moody/helpers/emoji_text.dart';
import 'package:Moody/models/conversation_model.dart';
import 'package:Moody/models/message_model.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:Moody/services/message_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen(
      {Key key,
      @required this.conversation,
      @required this.toUser,
      @required this.authService})
      : super(key: key);

  final ConversationModel conversation;
  final UserModel toUser;
  final AuthService authService;

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  int lastIndexRequested = -1;
  bool handlerSet = false;
  Socket socket;
  List<MessageModel> messages = List<MessageModel>();
  MessageService messageService;
  GlobalKey messageViewBuilderKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    socket = io(kApiUrl, <String, dynamic>{
      'transports': ['websocket'],
      'query': {
        'conversation': widget.conversation.sId,
        'token': widget.authService.auth.token,
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    messageService = Provider.of<MessageService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage:
                    ExtendedNetworkImageProvider(widget.toUser.profilePicUrl),
                radius: 17,
              ),
              SizedBox(
                width: 10,
              ),
              Text(widget.toUser.userName)
            ],
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            StatefulBuilder(
              key: messageViewBuilderKey,
              builder: (context, setMessagesState) {
                if (!handlerSet) {
                  socket.on('message', (data) {
                    final parsedData = jsonDecode(data);
                    final String id = parsedData['uniqueId'];
                    final message =
                        MessageModel.fromJson(parsedData['message']);
                    int index =
                        messages.indexWhere((element) => element.sId == id);

                    Function addMessage = () {
                      if (index != -1) {
                        messages[index] = message;
                      } else {
                        messages.insert(0, message);
                      }
                      final messageService =
                          Provider.of<MessageService>(context, listen: false);
                      messageService.updateConversation(
                          widget.conversation.sId, messages);
                    };

                    if (mounted)
                      setMessagesState(() {
                        addMessage();
                      });
                  });
                  handlerSet = true;
                }
                return Expanded(
                  child: CustomScrollView(
                    reverse: true,
                    slivers: [
                      SliverPadding(
                        padding: EdgeInsets.only(
                          top: 10,
                          bottom: 10,
                        ),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              if (index < messages.length) {
                                final message = messages.elementAt(index);
                                return Message(
                                  message: message,
                                  right: message.from.sId ==
                                      messageService.authService.user.sId,
                                  hasDetails: index == 0,
                                );
                              } else {
                                if (lastIndexRequested < index) {
                                  lastIndexRequested = index + 1;
                                  messageService
                                      .getMessages(widget.conversation.sId,
                                          offset: messages.length)
                                      .then((value) {
                                    if (this.mounted)
                                      setMessagesState(() {
                                        messages.addAll(value);
                                      });
                                  });

                                  return Padding(
                                    padding: EdgeInsets.all(25),
                                    child: Loader(),
                                  );
                                }

                                return null;
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            BottomSingleTextFieldForm(
              onSend: (text) {
                final newMessage = MessageModel(
                  content: text,
                  conversation: widget.conversation.sId,
                  from: widget.authService.user,
                );

                messageViewBuilderKey.currentState.setState(() {
                  messages.insert(
                    0,
                    newMessage,
                  );
                });

                socket.emit('message', {
                  'message': text,
                  'uniqueId': newMessage.sId,
                });
              },
            ),
          ],
        ));
  }
}

class Message extends StatelessWidget {
  const Message(
      {Key key, this.message, this.right = false, this.hasDetails = false})
      : super(key: key);

  final MessageModel message;
  final bool right;
  final bool hasDetails;

  @override
  Widget build(BuildContext context) {
    final shouldBeBig = message.content.runes.length <= 5 &&
        message.content.runes.any((element) => element > 256);

    return Opacity(
      opacity: message.sent ? 1 : .5,
      child: Padding(
        padding: shouldBeBig
            ? EdgeInsets.zero
            : const EdgeInsets.only(top: 2.5, bottom: 2.5, right: 10, left: 10),
        child: Column(
          crossAxisAlignment:
              this.right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment:
                  this.right ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  constraints: BoxConstraints.loose(Size.fromWidth(250)),
                  decoration: shouldBeBig
                      ? null
                      : BoxDecoration(
                          color: this.right ? kPrimaryColor : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [if (!right) BoxShadow()]),
                  child: Text.rich(
                    buildTextSpansWithEmojiSupport(
                      message.content,
                      style: TextStyle(
                        color: this.right ? Colors.white : Colors.black87,
                        fontSize: shouldBeBig ? 35 : 16,
                      ),
                    ),
                    textAlign: shouldBeBig
                        ? this.right ? TextAlign.right : TextAlign.left
                        : null,
                  ),
                )
              ],
            ),
            if (this.right && this.hasDetails)
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: shouldBeBig ? 19 : 5,
                    vertical: shouldBeBig ? 0 : 2.5),
                child: Text(
                  _buildMessageDetails(),
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[600],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _buildMessageDetails() {
    String details = 'Sending...';
    if (message.sent) {
      details = 'Sent';
      if (message.delivered) {
        details = 'Delivered';
        if (message.seen) {
          details = 'Seen';
        }
      }
      final sentTime = DateTime.parse(message.createdAt);
      final hour =
          sentTime.hour > 9 ? sentTime.hour.toString() : '0${sentTime.hour}';
      final min = sentTime.minute > 9
          ? sentTime.minute.toString()
          : '0${sentTime.minute}';
      details += ' $hour:$min';
    }
    return details;
  }
}
