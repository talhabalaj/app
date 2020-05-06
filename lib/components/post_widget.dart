import 'package:app/models/post_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/post_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatefulWidget {
  final PostModel post;

  const PostWidget({Key key, this.post}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  PostService postServce;
  AuthService authService;

  Future<void> toggleLike() async {
    widget.post.likes.indexOf(authService.user.sId) == -1
        ? await postServce.like(widget.post)
        : await postServce.unlike(widget.post);
  }

  @override
  void didChangeDependencies() {
    postServce = Provider.of<PostService>(context);
    authService = Provider.of<AuthService>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        PostTopBar(
          user: widget.post.user,
        ),
        Container(
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(
                color: Colors.grey[300],
              ),
              bottom: BorderSide(
                color: Colors.grey[300],
              ),
            ),
          ),
          child: ExtendedImage.network(
            widget.post.imageUrl,
            cache: true,
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.width,
            mode: ExtendedImageMode.gesture,
            initGestureConfigHandler: (state) => GestureConfig(
              minScale: 1,
              maxScale: 2,
            ),
            onDoubleTap: (state) async {
              await toggleLike();
            },
          ),
        ),
        IconTheme(
          data: IconThemeData(color: Colors.grey[800], size: 30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: BorderDirectional(
                bottom: BorderSide(
                  color: Colors.grey[300],
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                IconButton(
                  icon: widget.post.likes.indexOf(authService.user.sId) == -1
                      ? Icon(
                          EvaIcons.heartOutline,
                          size: 30,
                        )
                      : Icon(
                          EvaIcons.heart,
                          color: Colors.red,
                          size: 30,
                        ),
                  onPressed: () async {
                    await toggleLike();
                  },
                ),
                IconButton(
                  icon: Icon(EvaIcons.messageSquareOutline),
                  iconSize: 30,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
        PostBottomDetails(post: widget.post),
        SizedBox(
          height: 30,
        ),
      ],
    );
  }
}

class PostTopBar extends StatelessWidget {
  const PostTopBar({Key key, this.user}) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          top: BorderSide(
            color: Colors.grey[300],
          ),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundImage: ExtendedNetworkImageProvider(
              user.profilePicUrl,
              cache: true,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text('${user.userName}'),
        ],
      ),
    );
  }
}

class PostBottomDetails extends StatelessWidget {
  const PostBottomDetails({Key key, this.post}) : super(key: key);

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '${post.likes.length} likes',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (post.caption != '')
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: post.user.userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " "),
                  TextSpan(text: post.caption)
                ],
              ),
            ),
        ],
      ),
    );
  }
}
