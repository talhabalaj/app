import 'package:app/models/post_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/post_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PostWidget extends StatelessWidget {
  final PostModel post;

  const PostWidget({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PostService postServce = Provider.of<PostService>(context);
    AuthService authService = Provider.of<AuthService>(context);
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            border: BorderDirectional(
              top: BorderSide(
                color: Colors.grey[300],
              ),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: ExtendedNetworkImageProvider(
                  post.user.profilePicUrl,
                  cache: true,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text('${post.user.userName}'),
            ],
          ),
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
            post.imageUrl,
            cache: true,
            fit: BoxFit.fill,
            height: MediaQuery.of(context).size.width,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: post.likes.indexOf(authService.user) == -1
                    ? Icon(EvaIcons.heartOutline)
                    : Icon(EvaIcons.heart),
                iconSize: 30,
                onPressed: () {
                  post.likes.indexOf(authService.user) == -1
                      ? postServce.like(post)
                      : postServce.unlike(post);
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
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${post.likes.length} likes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
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
              )
            ],
          ),
        )
      ],
    );
  }
}
