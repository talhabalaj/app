import 'package:Moody/components/loader.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    Key key,
    this.child,
    @required this.onPressed,
    this.loading = false,
  }) : super(key: key);

  final Widget child;
  final Function onPressed;
  final bool loading;

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
      child: loading
          ? SizedBox(
              width: 50,
              child: Loader(
                size: 12, //
                color: Colors.white,
              ),
            )
          : child,
    );
  }
}
