import 'package:Moody/components/loader.dart';
import 'package:Moody/components/user_list_item.dart';
import 'package:Moody/helpers/navigation.dart';
import 'package:Moody/screens/conversation_screen.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:Moody/services/message_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateConversationScreen extends StatefulWidget {
  CreateConversationScreen({Key key}) : super(key: key);

  @override
  _CreateConversationScreenState createState() =>
      _CreateConversationScreenState();
}

class _CreateConversationScreenState extends State<CreateConversationScreen> {
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final AuthService authService =
        Provider.of<AuthService>(context, listen: false);
    final messageService = Provider.of<MessageService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Select User"),
      ),
      body: Stack(
        children: <Widget>[
          if (loading) Center(child: Loader()),
          if (authService.user.followers.length == 0)
            Center(child: Text('No followers to create conversation with.')),
          ListView.builder(
            itemCount: authService.user.followers.length,
            itemBuilder: (context, index) => UserListItem(
              user: authService.user.followers[index],
              onTap: () async {
                if (!loading) {
                  setState(() {
                    this.loading = true;
                  });
                  final conversation = await messageService.createConversation(
                      authService.user.followers[index].sId);
                  this.loading = false;
                  gotoPageWithAnimation(
                    context: context,
                    page: ConversationScreen(
                      conversation: conversation,
                      toUser: authService.user.followers[index],
                      authService: authService,
                    ),
                    name: '/messages/${conversation.sId}',
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
