import 'package:Moody/components/loader.dart';
import 'package:Moody/components/post_widget.dart';
import 'package:Moody/helpers/dialogs.dart';
import 'package:Moody/services/feed_service.dart';
import 'package:flutter/material.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class FeedWidget extends StatefulWidget {
  final FeedService feedService;

  const FeedWidget({Key key, @required this.feedService}) : super(key: key);

  @override
  _FeedWidgetState createState() => _FeedWidgetState();
}

class _FeedWidgetState extends State<FeedWidget> {
  FeedService feedService;
  int indexRequested = 0;

  @override
  void initState() {
    feedService = widget.feedService;
    super.initState();
  }

  Future<void> refreshFeed() async {
    try {
      await feedService.refreshFeed();
    } on WebErrorResponse catch (e) {
      showErrorDialog(context: context, e: e);
    } catch (e) {
      print(e);
    }
  }

  Future<void> initFeed() async {
    try {
      await feedService.initFeed();
    } on WebErrorResponse catch (e) {
      showErrorDialog(context: context, e: e);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (feedService.feed == null) return Loader();

    final feed = feedService.feed;

    return RefreshIndicator(
      onRefresh: () async {
        await refreshFeed();
      },
      child: ListView.builder(
        physics: AlwaysScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          if (index < feed.posts.length) {
            return PostWidget(
              post: feed.posts[index],
            );
          } else {
            if (indexRequested < index && feed.posts.length != 0) {
              feedService.getOldPost();
              indexRequested = index + 1;
              return Loader();
            }

            if (feed.posts.length == 0 && index == 0) {
              final child = feedService.loading
                  ? Loader()
                  : Text(
                      'No posts to show',
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    );
              return Container(
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 50,
                child: child,
              );
            }
            return null;
          }
        },
      ),
    );
  }
}
