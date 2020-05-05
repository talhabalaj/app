import 'package:app/components/feed_widget.dart';
import 'package:app/models/error_response_model.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/feed_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Moody",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[300]),
        ),
        actions: <Widget>[
          if (auth.auth != null)
            IconButton(
              icon: Icon(
                EvaIcons.logOut,
              ),
              onPressed: () async {
                try {
                  await auth.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.id, (Route<dynamic> route) => false);
                } on WebApiErrorResponse catch (e) {
                  print(e.message);
                }
              },
            ),
        ],
      ),
      body: Consumer<FeedService>(
        builder: (context, feedService, _) => FeedWidget(
          feedService: feedService,
        ),
      ),
    );
  }
}
