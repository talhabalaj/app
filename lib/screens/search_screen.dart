import 'package:Moody/components/loader.dart';
import 'package:Moody/components/primary_textfield.dart';
import 'package:Moody/components/user_list_item.dart';
import 'package:Moody/helpers/dialogs.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/services/search_service.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  SearchService searchService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    searchService = Provider.of<SearchService>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          child: SearchField(searchService: searchService),
        ),
      ),
      body: Container(
        child: Column(
          children: searchService.loading
              ? <Widget>[
                  for (int i = 0; i < searchService.list.length + 1; i++)
                    UserListItem(
                      user: null,
                    ),
                ]
              : <Widget>[
                  if (searchService.list.length > 0)
                    ...searchService.list
                        .map(
                          (user) => UserListItem(
                            user: user,
                          ),
                        )
                        .toList()
                  else
                    Container(
                      padding: EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: Text(
                          searchService.searchTerm.length > 0
                              ? 'No result found!'
                              : 'Type in the search bar to search!',
                          style: TextStyle(color: Colors.grey[500])),
                    )
                ],
        ),
      ),
    );
  }
}

class SearchField extends StatefulWidget {
  SearchField({
    Key key,
    @required this.searchService,
  }) : super(key: key);

  final SearchService searchService;

  @override
  _SearchFieldState createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PrimaryStyleTextField(
        controller: controller,
        hintText: 'Search',
        prefixIcon: Icon(
          EvaIcons.search,
          color: Color(0xff878787),
        ),
        suffixIcon: controller.value.text != ''
            ? IconButton(
                icon: Icon(
                  EvaIcons.close,
                  color: Colors.grey[500],
                ),
                onPressed: () {
                  controller.clear();
                  widget.searchService.search('');
                },
              )
            : null,
        onChanged: (value) async {
          try {
            await widget.searchService.search(value);
          } on WebErrorResponse catch (e) {
            showErrorDialog(context: context, e: e);
          }
        });
  }
}
