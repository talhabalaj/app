import 'dart:convert';

import 'package:Moody/components/loader.dart';
import 'package:Moody/components/primary_textfield.dart';
import 'package:Moody/constants.dart';
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
  TextEditingController controller = TextEditingController();
  int lastIndexRequested = 0;
  bool loading = true;
  Socket socket;
  List<MessageModel> messages = List<MessageModel>();
  MessageService messageService;
  GlobalKey<AnimatedListState> animatedListKey = GlobalKey<AnimatedListState>();
  String message = '';

  Future<void> getMessages({int offset = 0}) async {
    loading = true;
    final newMessages = await messageService
        .getMessages(widget.conversation.sId, offset: offset);

    setState(() {
      messages.addAll(newMessages);
      loading = false;
    });
  }

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

    socket.on('message', (data) {
      final parsedData = jsonDecode(data);
      final String id = parsedData['uniqueId'];
      final message = MessageModel.fromJson(parsedData['message']);
      int index = messages.indexWhere((element) => element.sId == id);

      Function addMessage = () {
        if (index != -1) {
          messages[index] = message;
        } else {
          messages.insert(0, message);
        }
      };

      if (mounted)
        this.setState(() {
          addMessage();
        });
    });
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
      body: ListView.builder(
        reverse: true,
        itemBuilder: (context, index) {
          if (index == 0) {
            return SizedBox(
              height: 70,
            );
          } else if (index < messages.length) {
            final message = messages.elementAt(index - 1);
            return Message(
              message: message,
              right: message.from.sId == messageService.authService.user.sId,
            );
          } else {
            if (lastIndexRequested < index) {
              lastIndexRequested = index + 1;
              getMessages(offset: messages.length);
              return Padding(padding: EdgeInsets.all(10), child: Loader());
            }

            return null;
          }
        },
      ),
      bottomSheet: StatefulBuilder(builder: (context, setMessageState) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(blurRadius: 2, color: Colors.black12)],
            color: Colors.white,
          ),
          padding: EdgeInsets.all(8),
          child: Row(
            children: <Widget>[
              Expanded(
                child: PrimaryStyleTextField(
                  controller: controller,
                  hintText: 'Message',
                  onChanged: (value) {
                    setMessageState(() {
                      message = value.trim();
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: message == ''
                    ? null
                    : () {
                        final newMessage = MessageModel(
                          content: controller.value.text,
                          conversation: widget.conversation.sId,
                          from: widget.authService.user,
                        );

                        this.setState(() {
                          messages.insert(
                            0,
                            newMessage,
                          );
                        });

                        socket.emit('message', {
                          'message': controller.value.text,
                          'uniqueId': newMessage.sId,
                        });

                        controller.clear();
                      },
              )
            ],
          ),
          height: 50,
        );
      }),
    );
  }
}

class Message extends StatelessWidget {
  const Message({Key key, this.message, this.right = false}) : super(key: key);

  final MessageModel message;
  final bool right;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: message.sent ? 1 : .5,
      child: Padding(
        padding: const EdgeInsets.only(top: 5, right: 10, left: 10),
        child: Row(
          mainAxisAlignment:
              this.right ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  color: this.right ? kPrimaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [if (!right) BoxShadow()]),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 175),
                child: Text(
                  message.content,
                  style: TextStyle(
                    color: this.right ? Colors.white : Colors.black87,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
