import 'dart:typed_data';

import 'package:Moody/helpers/dialogs.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/models/post_model.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/screens/people_list_screen.dart';
import 'package:Moody/screens/post_screen.dart';
import 'package:Moody/screens/profile_screen.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:Moody/services/feed_service.dart';
import 'package:Moody/services/post_service.dart';
import 'package:Moody/services/user_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:simple_moment/simple_moment.dart';

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
    final bool isNetworkPost = widget.post.stateType == PostStateType.NETWORK;
    final Function like = isNetworkPost
        ? () async {
            await toggleLike();
          }
        : null;
    final Function comment = isNetworkPost ? () {} : null;

    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (!isNetworkPost) LinearProgressIndicator(),
        PostTopBar(
          post: widget.post,
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
          child: isNetworkPost
              ? ExtendedImage.network(
                  widget.post.imageUrl,
                  cache: true,
                  fit: BoxFit.fill,
                  height: MediaQuery.of(context).size.width,
                  mode: ExtendedImageMode.gesture,
                  initGestureConfigHandler: (state) => GestureConfig(
                    minScale: 1,
                    maxScale: 2,
                  ),
                  onDoubleTap: (state) => like,
                )
              : ExtendedImage.memory(
                  Uint8List.fromList(widget.post.image),
                  height: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
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
                  onPressed: like,
                ),
                IconButton(
                  icon: Icon(EvaIcons.messageSquareOutline),
                  iconSize: 30,
                  onPressed: comment,
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
  const PostTopBar({Key key, this.post}) : super(key: key);

  final PostModel post;

  @override
  Widget build(BuildContext context) {
    final loggedInUser = Provider.of<AuthService>(context, listen: false).user;

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                PageTransition(
                  type: PageTransitionType.transferRight,
                  child: ProfileScreen(
                    user: post.user,
                  ),
                ),
              );
            },
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
          if (post.user.sId == loggedInUser.sId)
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'delete') {
                  bool choice = await showConfirmationDialog(
                    context: context,
                    title: "Delete post",
                    desc: "Are you sure you want to delete this post?",
                  );
                  if (choice) {
                    try {
                      await Provider.of<FeedService>(context, listen: false)
                          .deletePost(post);
                    } on WebErrorResponse catch (e) {
                      showErrorDialog(context: context, e: e);
                    }
                  }
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem<String>(
                  child: Text('Delete'),
                  value: 'delete',
                )
              ],
            )
        ],
      ),
    );
  }
}

class PostBottomDetails extends StatelessWidget {
  const PostBottomDetails({Key key, this.post}) : super(key: key);

  final PostModel post;

  Widget getLikesDescription(context) {
    final loggedInUser = Provider.of<AuthService>(context, listen: false).user;
    final knownLikers = loggedInUser.following
        .where((f) => post.likes.indexOf(f.sId) != -1)
        .toList()
          ..shuffle();
    final textStyle = TextStyle(fontWeight: FontWeight.bold);
    Widget likeWidget = Text('${post.likes.length} likes', style: textStyle);

    if (knownLikers.length > 0) {
      List<Widget> likeWidgetList = [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: CircleAvatar(
            radius: 10,
            backgroundImage:
                ExtendedNetworkImageProvider(knownLikers[0].profilePicUrl),
          ),
        ),
        Text(
          'Liked by ',
          style: textStyle,
        ),
        Text(knownLikers[0].userName, style: textStyle),
      ];
      if (post.likes.length - 1 > 0)
        likeWidgetList.add(
          Text(
            ' and ${post.likes.length - 1} others',
            style: textStyle,
          ),
        );

      likeWidget = Row(
        children: likeWidgetList,
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageTransition(
            child: PeopleListScreen(
              list: post.likes,
              listTitle: "Likers",
            ),
            type: PageTransitionType.transferRight,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: likeWidget,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          getLikesDescription(context),
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
          if (post.createdAt != null)
            Text(
              Moment.fromDate(
                DateTime.now(),
              ).from(
                DateTime.parse(post.createdAt),
              ),
              style: TextStyle(
                color: Colors.grey[500],
                fontSize: 12,
              ),
            )
        ],
      ),
    );
  }
}

class UserPosts extends StatefulWidget {
  final UserModel user;

  UserPosts({this.user});

  @override
  _UserPostsState createState() => _UserPostsState();
}

class _UserPostsState extends State<UserPosts> {
  bool postsLoading = true;
  UserService userService;
  List<PostModel> userPosts;
  int lastIndexFetched;

  Future<List<PostModel>> getUserPosts({int offset = 0}) async {
    if (widget.user == null)
      return this.userService.getUserPosts(offset: offset);
    else
      return this.userService.getUserPosts(id: widget.user.sId, offset: offset);
  }

  @override
  void didChangeDependencies() {
    userService = Provider.of<UserService>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        List<PostModel> posts = await getUserPosts();

        this.setState(() {
          userPosts = posts;
          postsLoading = false;
          lastIndexFetched = 0;
        });
      } catch (e) {
        print(e);
      }
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return postsLoading
        ? SpinKitChasingDots(
            color: Theme.of(context).accentColor,
          )
        : Container(
            color: Colors.grey[100],
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1 / 1,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              shrinkWrap: true,
              itemCount: userPosts.length + 1,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                if (index < userPosts.length) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        PageTransition(
                          type: PageTransitionType.transferUp,
                          child: PostScreen(post: userPosts[index]),
                        ),
                      );
                    },
                    child: ExtendedImage.network(
                      userPosts[index].imageUrl,
                      cache: true,
                    ),
                  );
                } else {
                  if (lastIndexFetched < index) {
                    lastIndexFetched = index + 1;

                    getUserPosts(offset: userPosts.length).then((value) {
                      this.setState(() {
                        userPosts.addAll(value);
                      });
                    });
                  }
                }
              },
            ),
          );
  }
}
