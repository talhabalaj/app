import 'package:Moody/components/feed_widget.dart';
import 'package:Moody/helpers/navigation.dart';
import 'package:Moody/screens/messages_screen.dart';
import 'package:Moody/services/feed_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
  FeedScreen({Key key, this.onMessageButtonClick}) : super(key: key);

  Function onMessageButtonClick;

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
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
        actions: <Widget>[
          IconButton(
            icon: Icon(EvaIcons.messageCircleOutline),
            onPressed: widget.onMessageButtonClick,
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
