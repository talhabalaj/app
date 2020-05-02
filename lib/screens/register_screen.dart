import 'dart:developer';

import 'package:app/components/button_seperator.dart';
import 'package:app/components/default_appbar.dart';
import 'package:app/components/styled_button.dart';
import 'package:app/components/styled_textfield.dart';
import 'package:app/constants.dart';
import 'package:app/screens/home_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/models/error_response.dart';

class RegisterScreen extends StatefulWidget {
  static String id = "/register";

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: buildRectroBar(context),
        body: ListView(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "REGISTER",
                    style: kTextStyle.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  RegisterForm(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final nameRegex = RegExp(r'/^[a-z]+$/');

  // Form fields
  String userName;
  String password;
  String firstName;
  String lastName;
  String email;

  // Controlling state
  bool loading = false;
  bool enabled = true;
  bool autovalidate = false;

  void handleSubmit() async {
    FocusScope.of(context).unfocus();
    this.setState(() {
      loading = true;
      enabled = false;
      autovalidate = true;
    });

    if (_formkey.currentState.validate()) {
      _formkey.currentState.save();
      final auth = Provider.of<AuthService>(context, listen: false);

      try {
        await auth.register(
          email: email,
          userName: userName,
          firstName: firstName,
          lastName: lastName,
          password: password,
        );
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
      }
    }

    this.setState(() {
      loading = false;
      enabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidate: autovalidate,
      key: _formkey,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: StyledTextField(
                  hintText: "First name",
                  labelText: "First name",
                  enabled: enabled,
                  onSaved: (text) {
                    this.firstName = text.trim();
                  },
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: StyledTextField(
                  hintText: "Last name",
                  labelText: "Last name",
                  enabled: enabled,
                  onSaved: (text) {
                    this.lastName = text.trim();
                  },
                ),
              ),
            ],
          ),
          StyledTextField(
            hintText: "Enter your username",
            labelText: "Username",
            enabled: enabled,
            onSaved: (text) {
              this.userName = text.trim();
            },
          ),
          StyledTextField(
            hintText: "Enter your email",
            labelText: "Email",
            enabled: enabled,
            onSaved: (text) {
              this.email = text.trim();
            },
          ),
          StyledTextField(
            hintText: "Enter your password",
            labelText: "Password",
            enabled: enabled,
            onSaved: (text) {
              this.password = text.trim();
            },
            password: true,
          ),
          StyledColoredButton(
            loading: loading,
            label: "Register",
            enabled: enabled,
            onPressed: () {
              handleSubmit();
            },
          ),
          ButtonSeparator(),
          StyledColoredButton(
            label: "Login",
            backgroundColor: Colors.grey[100],
            outlined: true,
            enabled: enabled,
            color: Theme.of(context).accentColor,
            onPressed: () {
              Navigator.of(context).popAndPushNamed(LoginScreen.id);
            },
          ),
        ],
      ),
    );
  }
}
