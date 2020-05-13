import 'package:Moody/helpers/dialogs.dart';
import 'package:Moody/models/error_response_model.dart';
import 'package:Moody/models/user_model.dart';
import 'package:Moody/screens/profile_screen.dart';
import 'package:Moody/services/search_service.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';
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
    searchService = Provider.of<SearchService>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          child: SearchField(searchService: searchService),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[300]),
        ),
      ),
      body: Container(
        child: Column(
          children: searchService.loading
              ? <Widget>[
                  Expanded(
                    child: SpinKitChasingDots(
                      color: Theme.of(context).accentColor,
                    ),
                  )
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

class SearchField extends StatelessWidget {
  const SearchField({
    Key key,
    @required this.searchService,
  }) : super(key: key);

  final SearchService searchService;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: searchService.searchTerm,
      onChanged: (value) async {
        try {
          await searchService.search(value);
        } on WebErrorResponse catch (e) {
          showErrorDialog(context: context, e: e);
        } on DioError catch (e) {
          if (e.type != DioErrorType.CANCEL) {
            print(e.error);
          } else {
            print('Cancelled!');
          }
        }
      },
      decoration: InputDecoration(
        hintText: 'Search',
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 5),
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
    );
  }
}

class UserListItem extends StatelessWidget {
  const UserListItem({
    Key key,
    @required this.user,
    this.chevron = true,
  }) : super(key: key);

  final bool chevron;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        FocusScope.of(context).unfocus();
        Navigator.push(
          context,
          PageTransition(
            child: ProfileScreen(user: user),
            type: PageTransitionType.transferRight,
          ),
        );
      },
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 22,
                backgroundImage:
                    ExtendedNetworkImageProvider(user.profilePicUrl),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    user.userName,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                  Text(
                    '${user.firstName} ${user.lastName}',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              )
            ],
          ),
          if (chevron) Icon(EvaIcons.chevronRight),
        ],
      ),
    );
  }
}
