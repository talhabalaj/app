import 'package:flutter/material.dart';

import '../constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key key,
    this.child,
    @required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      color: kPrimaryColor,
      textColor: Colors.white,
      disabledColor: kPrimaryColorDark,
      disabledTextColor: Colors.white60,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      onPressed: onPressed,
      child: child,
    );
  }
}
