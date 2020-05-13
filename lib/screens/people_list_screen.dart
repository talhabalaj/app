import 'package:Moody/models/user_model.dart';
import 'package:Moody/screens/search_screen.dart';
import 'package:Moody/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PeopleListScreen extends StatefulWidget {
  PeopleListScreen({Key key, @required this.list, @required this.listTitle})
      : super(key: key);

  List<String> list;
  String listTitle;

  @override
  _PeopleListScreenState createState() => _PeopleListScreenState();
}

class _PeopleListScreenState extends State<PeopleListScreen> {
  bool loading = true;
  Map<String, UserModel> userMap = new Map<String, UserModel>();

  UserModel getUser(int index) {
    final userId = widget.list[index];

    if (userMap.containsKey(userId)) return userMap[userId];
    final userService = Provider.of<UserService>(context);



  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.listTitle),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => UserListItem(
          user: getUser(index),
          chevron: false,
        ),
        itemCount: widget.list.length,
      ),
    );
  }
}
