import 'package:app/models/user.dart';

class AuthToken {
  final String token;
  final User user;
  final bool isValid;

  AuthToken({this.token, this.user, this.isValid});
}
