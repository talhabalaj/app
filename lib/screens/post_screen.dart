import 'package:Moody/components/post_widget.dart';
import 'package:Moody/models/post_model.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  final PostModel post;

  PostScreen({@required this.post});

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: PostWidget(
        post: widget.post,
      ),
    );
  }
}
