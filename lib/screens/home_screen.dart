import 'package:Moody/helpers/dialogs.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/models/post_model.dart';
import 'package:Moody/screens/edit_image_screen.dart';
import 'package:Moody/screens/feed_screen.dart';
import 'package:Moody/screens/notification_screen.dart';
import 'package:Moody/screens/search_screen.dart';
import 'package:Moody/screens/user_screen.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:Moody/services/feed_service.dart';
import 'package:animations/animations.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
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

  List<Widget> tabs = [
    FeedScreen(),
    SearchScreen(),
    NotificationScreen(),
    UserScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final image = await ImagePicker.pickImage(
                source: ImageSource.gallery, imageQuality: 100);

            if (image != null) {
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: PageTransitionSwitcher(
          transitionBuilder: (
            Widget child,
            Animation<double> primaryAnimation,
            Animation<double> secondaryAnimation,
          ) =>
              FadeThroughTransition(
            child: child,
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
          ),
          child: tabs[index],
        ),
        bottomNavigationBar: StyledBottomNav(
          index: index,
          onTap: (i) {
            this.setState(() {
              index = i;
            });
          },
        ),
      ),
    );
  }
}

class StyledBottomNav extends StatelessWidget {
  final int index;
  final Function(int) onTap;

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
  }) : super(key: key);

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
            IconButton(
              icon: index == (itr.key + leftIcons.length)
                  ? iconSelected[(itr.key + leftIcons.length)]
                  : itr.value,
              onPressed: () {
                onTap(itr.key + leftIcons.length);
              },
            ),
        ],
      ),
    );
  }
}
