import 'package:Moody/components/post_widget.dart';
import 'package:Moody/components/primary_button.dart';
import 'package:Moody/components/profile_widget.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/services/auth_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  AuthService authService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    authService = Provider.of<AuthService>(context);
  }

  @override
  Widget build(BuildContext context) {
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
                } on WebErrorResponse catch (e) {
                  print(e.message);
                }
              },
            ),
        ],
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          ProfileWidget(
            user: authService.user,
          ),
          Center(
            child: PrimaryButton(
              child: Text('Edit profile'),
              onPressed: null,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          UserPosts(
            user: authService.user,
          )
        ],
      ),
    );
  }
}
