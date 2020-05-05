import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String searchTerm;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          height: 38,
          child: TextField(
            onChanged: (value) => searchTerm = value,
            decoration: InputDecoration(
              hintText: 'Search',
              contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(9),
                borderSide: BorderSide(
                  style: BorderStyle.none,
                  width: 0,
                ),
              ),
              filled: true,
              prefixIcon: Icon(
                EvaIcons.search,
                color: Color(0xff878787),
              ),
              fillColor: Color(0xffEBEBEB),
              hintStyle: TextStyle(
                color: Color(0xff878787),
              ),
              focusColor: Colors.red,
            ),
            maxLines: 1,
            expands: false,
          ),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[300]),
        ),
      ),
    );
  }
}
