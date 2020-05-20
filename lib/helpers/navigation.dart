import 'package:flutter/material.dart';
import 'package:flutter_page_transition/flutter_page_transition.dart';

Future<void> gotoPageWithAnimation(
    {Widget page,
    @required BuildContext context,
    PageTransitionType type = PageTransitionType.slideInLeft}) async {
  return Navigator.push(
    context,
    PageTransition(
      duration: Duration(milliseconds: 300),
      child: page,
      type: type,
    ),
  );
}
