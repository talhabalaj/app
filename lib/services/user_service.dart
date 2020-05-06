import 'package:app/models/user_model.dart';
import 'package:app/services/auth_service.dart';
import 'package:flutter/widgets.dart';

class UserService extends ChangeNotifier {
  UserModel _user;
  AuthService authService;

  UserModel get user => _user;

  UserService({this.authService});
}
