import 'package:Moody/components/feed_widget.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:Moody/services/feed_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedScreen extends StatefulWidget {
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
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[300]),
        ),
      ),
      body: Consumer<FeedService>(
        builder: (context, feedService, _) => FeedWidget(
          feedService: feedService,
        ),
      ),
    );
  }
}
