import 'package:Moody/components/user_list_item.dart';
import 'package:Moody/helpers/emoji_text.dart';
import 'package:Moody/helpers/navigation.dart';
import 'package:Moody/models/conversation_model.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/screens/conversation_screen.dart';
import 'package:Moody/screens/create_convo_screen.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:Moody/services/message_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessagesScreen extends StatefulWidget {
  MessagesScreen({Key key, this.onBack}) : super(key: key);

  final Function onBack;

  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  MessageService messageService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    messageService = Provider.of<MessageService>(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        widget.onBack();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Messages'),
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: Icon(EvaIcons.arrowBack),
            onPressed: widget.onBack,
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(EvaIcons.plus),
                onPressed: () {
                  gotoPageWithAnimation(
                    context: context,
                    page: CreateConversationScreen(),
                  );
                })
          ],
        ),
        body: CustomScrollView(
          slivers: <Widget>[
            // SliverToBoxAdapter(
            //   child: Container(
            //     padding: EdgeInsets.symmetric(horizontal: 15),
            //     margin: EdgeInsets.symmetric(vertical: 15),
            //     child: PrimaryStyleTextField(
            //       hintText: 'Search',
            //       hasBorder: true,
            //     ),
            //   ),
            // ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  if (messageService.loading &&
                      messageService.conversations == null) {
                    return Column(
                      children: <Widget>[
                        for (int i = 0; i < 9; i++)
                          Opacity(
                            opacity: (9 - i) / 9 > 0 ? (9 - i) / 9 : 0,
                            child: UserListItem(
                              user: null,
                              chevron: false,
                            ),
                          ),
                      ],
                    );
                  } else if (messageService.conversations.length == 0) {
                    return Text('No conversions are here.');
                  } else {
                    final memberExceptUser = messageService
                        .conversations[index].members
                        .firstWhere((element) =>
                            element.sId != messageService.authService.user.sId);
                    return UserConversation(
                      user: memberExceptUser,
                      conversation: messageService.conversations[index],
                    );
                  }
                },
                childCount: (messageService.conversations == null ||
                        messageService.conversations?.length == 0)
                    ? 1
                    : messageService.conversations.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserConversation extends StatelessWidget {
  const UserConversation(
      {Key key, @required this.user, @required this.conversation})
      : super(key: key);

  final UserModel user;
  final ConversationModel conversation;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey[100],
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.grey[300],
                  backgroundImage:
                      ExtendedNetworkImageProvider(user.profilePicUrl),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text(
                        user.userName,
                        style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      if (conversation.messages.length > 0)
                        Text.rich(
                          buildTextSpansWithEmojiSupport(
                            conversation.messages[0].content,
                            style: TextStyle(fontSize: 14),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
      onPressed: () {
        gotoPageWithAnimation(
            context: context,
            page: ConversationScreen(
              conversation: conversation,
              toUser: user,
              authService: Provider.of<AuthService>(context, listen: false),
            ));
      },
    );
  }
}
