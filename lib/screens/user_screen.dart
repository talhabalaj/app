import 'package:app/components/profile_widget.dart';
import 'package:app/models/error_response_model.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/feed_service.dart';
import 'package:app/services/post_service.dart';
import 'package:app/services/search_service.dart';
import 'package:app/services/user_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    final AuthService authService = Provider.of<AuthService>(context);
    if (authService.user == null) return Text('Not loading');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          authService.user.userName,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[300]),
        ),
        actions: <Widget>[
          if (authService.auth != null)
            IconButton(
              icon: Icon(
                EvaIcons.logOut,
              ),
              onPressed: () async {
                try {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.id, (Route<dynamic> route) => false);
                  await authService.logout();
                } on WebApiErrorResponse catch (e) {
                  print(e.message);
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          ProfileWidget(
            user: authService.user,
          ),
          RaisedButton(
            child: Text('Edit profile'),
            onPressed: () {},
          ),
          SizedBox(
            height: 30,
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1 / 1,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                ExtendedImage.network(authService.user.profilePicUrl),
                ExtendedImage.network(authService.user.profilePicUrl),
              ],
            ),
          )
        ],
      ),
    );
  }
}
