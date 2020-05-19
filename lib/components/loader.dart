import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      color: Theme.of(context).accentColor,
      size: 30,
      lineWidth: 2,
    );
  }
}
