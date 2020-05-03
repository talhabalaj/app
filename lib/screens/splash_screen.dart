import 'package:app/screens/home_screen.dart';
import 'package:app/screens/login_screen.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  static final id = "/";
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Text("Loading"),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() async {
    final auth = Provider.of<AuthService>(context, listen: false);
    try {
      await auth.load();
      Navigator.popAndPushNamed(context, HomeScreen.id);
    } catch (e) {
      Navigator.popAndPushNamed(context, LoginScreen.id);
    }
    super.didChangeDependencies();
  }
}
