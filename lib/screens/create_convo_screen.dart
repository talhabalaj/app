import 'package:Moody/components/loader.dart';
import 'package:Moody/components/user_list_item.dart';
import 'package:Moody/models/user_model.dart';
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
  TextEditingController _controller = TextEditingController();
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
          ListView(
            children: <Widget>[
              for (UserModel follower in authService.user.followers)
                UserListItem(
                  user: follower,
                  onTap: () async {
                    if (!loading) {
                      setState(() {
                        this.loading = true;
                      });
                      final conversation =
                          await messageService.createConversation(follower.sId);
                      this.loading = false;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ConversationScreen(
                            conversation: conversation,
                            toUser: follower,
                            authService: Provider.of<AuthService>(context,
                                listen: false),
                          ),
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}
