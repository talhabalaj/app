import 'package:Moody/components/loader.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:Moody/components/primary_textfield.dart';
import 'package:Moody/helpers/random.dart';
import 'package:Moody/models/comment_model.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/models/post_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:Moody/services/post_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:toast/toast.dart';

class PostCommentsScreen extends StatefulWidget {
  PostCommentsScreen({Key key, this.postId}) : super(key: key);

  final String postId;

  @override
  _PostCommentsScreenState createState() => _PostCommentsScreenState();
}

class _PostCommentsScreenState extends State<PostCommentsScreen> {
  PostService postService;
  AuthService authService;
  TextEditingController controller;
  bool loading = true;
  PostModel post;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    postService = Provider.of<PostService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    controller = TextEditingController();
    postService.getPost(widget.postId).then((value) {
      if (this.mounted)
        this.setState(() {
          post = value;
          loading = false;
        });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> commentOnPost() async {
    String comment = controller.text;
    if (comment != '') {
      String newCommentTempId = RandomString.createCryptoRandomString();
      controller.clear();
      this.setState(() {
        post.comments.add(
          CommentModel(
            message: comment,
            user: authService.user,
            isProcessing: true,
            sId: newCommentTempId,
          ),
        );
      });

      try {
        final req = await postService.comment(post, comment);
        this.setState(() {
          int index = post.comments
              .indexWhere((comment) => comment.sId == newCommentTempId);
          post.comments[index] = req.data;
        });
      } on WebErrorResponse catch (e) {
        Toast.show(e.message, context);
      }
    } else {
      Toast.show('Empty message not allowed!', context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Comments'),
        ),
        body: loading
            ? Loader()
            : RefreshIndicator(
                onRefresh: () async {
                  postService.getPost(widget.postId).then((value) {
                    if (this.mounted)
                      this.setState(() {
                        post = value;
                      });
                  });
                },
                child: ListView(
                  children: <Widget>[
                    if (post.caption != '')
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 14,
                                  backgroundImage: ExtendedNetworkImageProvider(
                                      post.user.profilePicUrl),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      post.user.userName,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      post.caption,
                                      softWrap: true,
                                    ),
                                    Text(
                                      Moment.now().from(
                                        DateTime.parse(post.createdAt),
                                      ),
                                      style: TextStyle(
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    Divider(),
                    if (post.comments.length == 0)
                      Container(
                        padding: EdgeInsets.all(20),
                        alignment: Alignment.center,
                        child: Text('No comments on this post.'),
                      ),
                    for (CommentModel comment in post.comments)
                      PostFullComment(
                        comment: comment,
                      ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                  physics: AlwaysScrollableScrollPhysics(),
                ),
              ),
        bottomSheet: Container(
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
                  hintText: 'Write a comment',
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  commentOnPost();
                },
              )
            ],
          ),
          height: 55,
        ),
      ),
    );
  }
}

class PostFullComment extends StatelessWidget {
  const PostFullComment({
    Key key,
    @required this.comment,
  }) : super(key: key);

  final CommentModel comment;

  Future<void> deleteComment() {}

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 14,
                    backgroundImage: ExtendedNetworkImageProvider(
                        comment.user.profilePicUrl),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          comment.user.userName,
                          style: TextStyle(
                            fontSize: 13,
                            color: comment.isProcessing
                                ? Colors.black45
                                : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          comment.message,
                          style: TextStyle(
                            color: comment.isProcessing
                                ? Colors.black45
                                : Colors.black,
                          ),
                        ),
                        if (!comment.isProcessing)
                          Text(
                            Moment.now().from(
                              DateTime.parse(comment.createdAt),
                            ),
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
