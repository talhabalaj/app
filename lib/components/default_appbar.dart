import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AppBar buildRectroBar(BuildContext context) {
  return AppBar(
    title: Text("Rectrogram"),
    centerTitle: true,
    automaticallyImplyLeading: false,
    elevation: 1,
    actions: <Widget>[
      IconButton(
        icon: Icon(
          Icons.input,
        ),
        onPressed: () {
          final auth = Provider.of<AuthService>(context);
        },
      ),
    ],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
    ),
  );
}
