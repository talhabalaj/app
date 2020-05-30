import 'dart:io';

import 'package:Moody/helpers/dialogs.dart';
import 'package:Moody/helpers/navigation.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/models/post_model.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/screens/edit_image_screen.dart';
import 'package:Moody/screens/feed_screen.dart';
import 'package:Moody/screens/messages_screen.dart';
import 'package:Moody/screens/notification_screen.dart';
import 'package:Moody/screens/post_comments_screen.dart';
import 'package:Moody/screens/profile_screen.dart';
import 'package:Moody/screens/search_screen.dart';
import 'package:Moody/screens/user_screen.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:Moody/services/feed_service.dart';
import 'package:Moody/services/notification_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static final id = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;
  PageController pageController;
  List<Widget> tabs;
  FirebaseMessaging fcm;
  bool isFCMConfigured = false;

  void gotoMessageScreen() {
    pageController.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  void goBackFromMessagesScreen() {
    pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.ease);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
    tabs = [
      FeedScreen(
        onMessageButtonClick: gotoMessageScreen,
      ),
      SearchScreen(),
      NotificationScreen(),
      UserScreen(),
    ];
  }

  Future<void> notificationHandler(Map<String, dynamic> msg) async {
    print('onLaunch/onResume: $msg');
    if (msg['data']['conversation_id'] != null) {
      this.gotoMessageScreen();
    } else if (msg['data']['comment_id'] != null &&
        msg['data']['post_id'] != null) {
      final String commentId = msg['data']['comment_id'];
      final String postId = msg['data']['post_id'];
      gotoPageWithAnimation(
        context: context,
        page: PostCommentsScreen(
          focusedCommentId: commentId,
          postId: postId,
          hasPost: true,
        ),
      );
    } else if (msg['data']['post_id'] != null) {
      final String postId = msg['data']['post_id'];
      gotoPageWithAnimation(
        context: context,
        page: PostCommentsScreen(
          postId: postId,
          hasPost: true,
        ),
      );
    } else if (msg['data']['user_id'] != null) {
      final String userId = msg['data']['user_id'];
      gotoPageWithAnimation(
        context: context,
        page: ProfileScreen(
          user: UserModel(
            sId: userId,
          ),
        ),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fcm = Provider.of<AuthService>(context, listen: false).fcm.fcm;
    if (!isFCMConfigured) {
      fcm.configure(
        onMessage: (message) async {
          // forground!
        },
        onLaunch: notificationHandler,
        onResume: notificationHandler,
      );
      isFCMConfigured = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final notificationService = Provider.of<NotificationService>(context);

    return SafeArea(
      child: PageView(controller: pageController, children: [
        Scaffold(
          resizeToAvoidBottomInset: false,
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              final pickedFile =
                  await ImagePicker().getImage(source: ImageSource.gallery);

              if (pickedFile != null) {
                final image = File(pickedFile.path);
                final imageEdited = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => EditImageScreen(image: image),
                  ),
                );

                if (imageEdited != null) {
                  this.setState(() {
                    index = 0;
                  });
                  final controller = TextEditingController();

                  await showDialog<String>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text("Add Caption"),
                      children: <Widget>[
                        TextField(
                          controller: controller,
                        ),
                        FlatButton(
                          child: Text("Done"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  );

                  String caption = controller.text;
                  final createPost = PostModel.inMemory(
                    image: imageEdited,
                    caption: caption,
                    user: Provider.of<AuthService>(context, listen: false).user,
                  );
                  try {
                    await Provider.of<FeedService>(context, listen: false)
                        .createPost(createPost);
                  } on WebErrorResponse catch (e) {
                    showErrorDialog(context: context, e: e);
                  }
                }
              }
            },
            child: Icon(EvaIcons.plus),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          body: IndexedStack(
            children: tabs,
            index: index,
          ),
          bottomNavigationBar: StyledBottomNav(
            index: index,
            newUnreadNotificationCount:
                notificationService.newUnreadNotificationCount,
            onTap: (i) {
              this.setState(() {
                index = i;
              });
            },
          ),
        ),
        MessagesScreen(
          onBack: this.goBackFromMessagesScreen,
        )
      ]),
    );
  }
}

class StyledBottomNav extends StatelessWidget {
  final int index;
  final Function(int) onTap;
  final int newUnreadNotificationCount;
  final String newUnreadNotificationString;

  final List<Icon> leftIcons = [
    Icon(EvaIcons.homeOutline),
    Icon(EvaIcons.searchOutline),
  ];

  final List<Icon> rightIcons = [
    Icon(EvaIcons.bellOutline),
    Icon(EvaIcons.personOutline),
  ];

  final List<Icon> iconSelected = [
    Icon(
      EvaIcons.home,
    ),
    Icon(
      EvaIcons.search,
    ),
    Icon(EvaIcons.bell),
    Icon(
      EvaIcons.person,
    ),
  ];

  StyledBottomNav({
    Key key,
    this.index,
    this.onTap,
    this.newUnreadNotificationCount = 0,
  })  : newUnreadNotificationString = newUnreadNotificationCount > 9
            ? '9+'
            : newUnreadNotificationCount.toString(),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
          border: BorderDirectional(top: BorderSide(color: Colors.grey[300]))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          for (final itr in leftIcons.asMap().entries)
            IconButton(
              icon: index == itr.key ? iconSelected[itr.key] : itr.value,
              onPressed: () {
                onTap(itr.key);
              },
            ),
          SizedBox(
            width: 20,
          ),
          for (final itr in rightIcons.asMap().entries)
            Stack(
              children: [
                IconButton(
                  icon: index == (itr.key + leftIcons.length)
                      ? iconSelected[(itr.key + leftIcons.length)]
                      : itr.value,
                  onPressed: () {
                    onTap(itr.key + leftIcons.length);
                  },
                ),
                if (itr.key == 0 && newUnreadNotificationCount > 0)
                  Positioned(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      padding: EdgeInsets.all(3),
                      child: Text(
                        newUnreadNotificationString,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    top: 5,
                    right: 13,
                  )
              ],
            ),
        ],
      ),
    );
  }
}
