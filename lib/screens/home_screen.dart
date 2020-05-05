import 'package:app/helpers/error_dialog.dart';
import 'package:app/models/create_post_model.dart';
import 'package:app/models/error_response_model.dart';
import 'package:app/screens/create_post_screen.dart';
import 'package:app/screens/feed_screen.dart';
import 'package:app/services/feed_service.dart';
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
  final List<Widget> tabs = [
    FeedScreen(),
    Text("Search"),
    Text("Notifications"),
    Text("Profile"),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final image =
                await ImagePicker.pickImage(source: ImageSource.gallery);

            if (image != null) {
              final createPost = await Navigator.of(context)
                  .pushNamed(CreatePostScreen.id, arguments: image);

              if (createPost is CreatePostModel) {
                try {
                  await Provider.of<FeedService>(context, listen: false)
                      .createPost(createPost);
                } on WebApiErrorResponse catch (e) {
                  showErrorDialog(context: context, e: e);
                }
              }
            }
          },
          child: Icon(EvaIcons.plus),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: tabs[index],
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
