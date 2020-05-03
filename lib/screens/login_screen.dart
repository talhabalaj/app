import 'dart:developer';
import 'dart:io';

import 'package:app/components/button_seperator.dart';
import 'package:app/components/default_appbar.dart';
import 'package:app/components/styled_button.dart';
import 'package:app/components/styled_textfield.dart';
import 'package:app/constants.dart';
import 'package:app/models/error_response.dart';
import 'package:app/screens/register_screen.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  static String id = "/login";

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildRectroBar(context),
        body: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Login to proceed",
                    style: kTextStyle.copyWith(
                      fontSize: 30,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  LoginForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String userName;
  String password;
  bool loading = false;
  bool enabled = true;

  void handleSubmit() async {
    // Drop the keyboard
    FocusScope.of(context).unfocus();

    // disable the form and show loading
    this.setState(() {
      loading = true;
      enabled = false;
    });

    if (_formkey.currentState.validate()) {
      final auth = Provider.of<AuthService>(context, listen: false);
      try {
        await auth.login(userName, password);
        Navigator.of(context).popAndPushNamed(HomeScreen.id);
      } on WebApiErrorResponse catch (e) {
        showDialog(
          context: context,
          child: AlertDialog(
            content: Text(e.message),
            contentTextStyle: kTextStyle,
            title: Text(e.type),
            actions: <Widget>[
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      } on SocketException catch (e) {
        Scaffold.of(context).showSnackBar(
          SnackBar(
            content: Text(e.osError.message),
            duration: Duration(seconds: 2),
          ),
        );
      }

      _formkey.currentState.reset();
    }

    this.setState(() {
      loading = false;
      enabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: false,
      key: _formkey,
      child: Column(
        children: <Widget>[
          StyledTextField(
            hintText: "Enter your username",
            labelText: "Username",
            enabled: enabled,
            onChanged: (text) {
              this.userName = text.trim();
            },
          ),
          StyledTextField(
            hintText: "Enter your password",
            labelText: "Password",
            enabled: enabled,
            onChanged: (text) {
              this.password = text.trim();
            },
            password: true,
          ),
          StyledColoredButton(
            loading: loading,
            label: "Login",
            enabled: enabled,
            onPressed: () {
              handleSubmit();
            },
          ),
          ButtonSeparator(),
          StyledColoredButton(
            label: "Register",
            outlined: true,
            enabled: enabled,
            backgroundColor: Colors.grey[100],
            color: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.of(context).pushNamed(RegisterScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
