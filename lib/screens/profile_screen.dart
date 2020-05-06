import 'package:app/components/profile_widget.dart';
import 'package:app/models/error_response_model.dart';
import 'package:app/services/auth_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final AuthService authService;

  ProfileScreen({this.authService});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.authService.user.userName,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[300]),
        ),
        actions: <Widget>[
          if (widget.authService.auth != null)
            IconButton(
              icon: Icon(
                EvaIcons.logOut,
              ),
              onPressed: () async {
                try {
                  await widget.authService.logout();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.id, (Route<dynamic> route) => false);
                } on WebApiErrorResponse catch (e) {
                  print(e.message);
                }
              },
            ),
        ],
      ),
      body: ProfileWidget(user: widget.authService.user),
    );
  }
}
