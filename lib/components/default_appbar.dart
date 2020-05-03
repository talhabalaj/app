import 'package:app/models/error_response.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

AppBar buildRectroBar(BuildContext context) {
  final auth = Provider.of<AuthService>(context);
  return AppBar(
    title: Text("Rectrogram"),
    automaticallyImplyLeading: false,
    actions: <Widget>[
      if (auth.auth != null)
        IconButton(
          icon: Icon(
            Icons.input,
          ),
          onPressed: () async {
            try {
              await auth.logout();
              Navigator.of(context).pushNamedAndRemoveUntil(
                  LoginScreen.id, (Route<dynamic> route) => false);
            } on WebApiErrorResponse catch (e) {
              print(e.message);
            }
          },
        ),
    ],
  );
}
