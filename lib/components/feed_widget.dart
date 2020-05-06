import 'dart:developer';
import 'dart:typed_data';

import 'package:app/components/post_widget.dart';
import 'package:app/helpers/error_dialog.dart';
import 'package:app/models/create_post_model.dart';
import 'package:app/services/feed_service.dart';
import 'package:app/services/post_service.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:app/models/error_response_model.dart';
import 'package:provider/provider.dart';

class FeedWidget extends StatefulWidget {
  final FeedService feedService;

  const FeedWidget({Key key, @required this.feedService}) : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  FeedService feedService;

  int indexRequested;

  Future<void> refreshFeed() async {
    try {
      await feedService.refreshFeed();
    } on WebApiErrorResponse catch (e) {
      showErrorDialog(context: context, e: e);
    } catch (e) {
      print(e);
    }
  }

  @override
  void didChangeDependencies() {
    feedService = widget.feedService;
    refreshFeed();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final PostService postService = Provider.of<PostService>(context);

    return RefreshIndicator(
      onRefresh: () async {
        await refreshFeed();
      },
      // for (final post in postService.postQueue)
      //   CreatePostWidget(post: post, feedService: feedService),
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          if (index < feedService.feed.posts.length) {
            return PostWidget(
              post: feedService.feed.posts[index],
            );
          } else {
            print('called $index');
            if (indexRequested <= index && feedService.feed.posts.length != 0) {
              print('called! old post getter!');
              feedService.getOldPost();
              indexRequested = index;
            }
            return null;
          }
        },
      ),
    );
  }
}

class CreatePostWidget extends StatefulWidget {
  const CreatePostWidget({
    Key key,
    @required this.post,
    @required this.feedService,
  }) : super(key: key);

  final CreatePostModel post;
  final FeedService feedService;

  @override
  _CreatePostWidgetState createState() => _CreatePostWidgetState();
}

class _CreatePostWidgetState extends State<CreatePostWidget>
    with TickerProviderStateMixin {
  AnimationController controller;
  Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    controller.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        child: Column(
          children: <Widget>[
            LinearProgressIndicator(),
            PostTopBar(user: widget.feedService.authService.user),
            ExtendedImage.memory(
              Uint8List.fromList(widget.post.image),
              height: MediaQuery.of(context).size.width,
              fit: BoxFit.fill,
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
