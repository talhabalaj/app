import 'package:flutter/material.dart';

Future<void> gotoPageWithAnimation(
    {Widget page, @required BuildContext context}) async {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}
