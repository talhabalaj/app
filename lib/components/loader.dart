import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatelessWidget {
  const Loader({Key key, this.color, this.size}) : super(key: key);

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SpinKitRing(
      color: this.color != null ? color : Theme.of(context).accentColor,
      size: this.size != null ? size : 30,
      lineWidth: 2,
    );
  }
}
