import 'package:app/helpers/error_dialog.dart';
import 'package:app/models/error_response_model.dart';
import 'package:app/models/user_model.dart';
import 'package:app/screens/profile_screen.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/user_service.dart';
import 'package:dio/dio.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  AuthService authService;
  UserService userService;

  String searchTerm = '';
  List<UserModel> list = new List<UserModel>();

  bool loading = false;
  bool searched = false;

  CancelToken cancelToken;

  @override
  void didChangeDependencies() {
    authService = Provider.of<AuthService>(context);
    userService = Provider.of<UserService>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          child: TextField(
            onChanged: (value) async {
              if (value == '') {
                setState(() {
                  list.removeRange(0, list.length);
                });
                return;
              }

              if (searched) {
                searched = false;
                cancelToken.cancel();
              }

              cancelToken = new CancelToken();

              this.setState(() {
                loading = true;
              });

              try {
                final data =
                    await userService.search(value, cancelToken: cancelToken);
                this.setState(() {
                  list = data;
                });
              } on WebApiErrorResponse catch (e) {
                showErrorDialog(context: context, e: e);
              } on DioError catch (e) {
                if (e.type != DioErrorType.CANCEL) {
                  throw e;
                } else {
                  print('Cancelled!');
                }
              }

              this.setState(() {
                loading = false;
              });
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
          ),
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey[300]),
        ),
      ),
      body: Container(
        child: Column(
          children: loading
              ? <Widget>[
                  Expanded(
                    child: SpinKitChasingDots(
                      color: Theme.of(context).accentColor,
                    ),
                  )
                ]
              : <Widget>[
                  if (list.length > 0)
                    ...list
                        .map(
                          (user) => UserSearchResult(
                            user: user,
                          ),
                        )
                        .toList()
                  else
                    Container(
                      padding: EdgeInsets.all(30),
                      alignment: Alignment.center,
                      child: Text(
                          searchTerm.length > 0
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

class UserSearchResult extends StatelessWidget {
  const UserSearchResult({
    Key key,
    @required this.user,
  }) : super(key: key);

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),
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
          Icon(EvaIcons.chevronRight),
        ],
      ),
    );
  }
}
