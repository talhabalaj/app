import 'package:app/components/post_widget.dart';
import 'package:app/helpers/error_dialog.dart';
import 'package:app/services/feed_service.dart';
import 'package:flutter/material.dart';
import 'package:app/models/error_response_model.dart';

class FeedWidget extends StatefulWidget {
  final FeedService feedService;

  const FeedWidget({Key key, @required this.feedService}) : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  FeedService feedService;

  Future<bool> refreshFeed() async {
    try {
      await feedService.refreshFeed();
      return true;
    } on WebApiErrorResponse catch (e) {
      showErrorDialog(context: context, e: e);
      return false;
    } catch (e) {
      throw e;
    }
  }

  @override
  void initState() {
    feedService = widget.feedService;
    refreshFeed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        await refreshFeed();
      },
      child: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          for (final post in feedService.feed.posts)
            PostWidget(
              post: post,
            )
        ],
      ),
    );
  }
}
