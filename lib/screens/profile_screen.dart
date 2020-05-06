import 'package:app/components/profile_widget.dart';
import 'package:app/models/error_response_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/services/user_service.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel user;

  ProfileScreen({@required this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = true;
  UserService userService;
  UserModel user;

  @override
  void didChangeDependencies() {
    userService = Provider.of<UserService>(context);
    getProfile();
    super.didChangeDependencies();
  }

  Future<void> getProfile() async {
    user = await userService.getUserProfile(widget.user.userName);
    this.setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.user.userName,
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[300]),
        ),
      ),
      body: loading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SpinKitChasingDots(
                  color: Theme.of(context).accentColor,
                ),
              ],
            )
          : Column(
              children: [
                ProfileWidget(user: user),
                RaisedButton(
                  onPressed: () {},
                  child: Text('Follow'),
                )
              ],
            ),
    );
  }
}
