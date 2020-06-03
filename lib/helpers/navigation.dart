import 'package:flutter/material.dart';

Future<T> gotoPageWithAnimation<T>({
  @required Widget page,
  @required BuildContext context,
  @required String name,
}) async {
  return Navigator.push<T>(
    context,
    MaterialPageRoute(
      builder: (context) => page,
      settings: RouteSettings(name: name),
    ),
  );
}
