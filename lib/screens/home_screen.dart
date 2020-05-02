import 'package:app/components/default_appbar.dart';
import 'package:app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static final id = "/home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return SafeArea(
      child: Scaffold(
        appBar: buildRectroBar(context),
        body: Container(
          width: double.infinity,
          child: Card(
            margin: EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('id: ${auth.auth.user.id}'),
                  Text('Name: ${auth.auth.user.name}'),
                  Text('Email: ${auth.auth.user.email}'),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              title: Text("Search"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
            ),
          ],
        ),
      ),
    );
  }
}
