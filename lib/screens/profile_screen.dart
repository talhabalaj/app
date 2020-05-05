import 'package:app/models/error_response_model.dart';
import 'package:app/services/auth_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_image/extended_image.dart';
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: double.infinity,
            height: 20,
          ),
          CircleAvatar(
            radius: 60,
            backgroundImage: ExtendedNetworkImageProvider(
              widget.authService.user.profilePicUrl,
              cache: true,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            '${widget.authService.user.firstName} ${widget.authService.user.lastName}',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              widget.authService.user.bio,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w100,
                color: Colors.grey[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
