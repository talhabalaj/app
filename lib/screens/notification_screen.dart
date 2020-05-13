import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Notifications",
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.grey[300],
          ),
        ),
      ),
      body: Container(),
    );
  }
}
