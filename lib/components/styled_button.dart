import 'package:app/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StyledColoredButton extends StatefulWidget {
  const StyledColoredButton(
      {Key key,
      this.label = "Button",
      this.backgroundColor,
      this.color = Colors.white,
      this.onPressed,
      this.loading = false,
      this.enabled = true,
      this.outlined = false})
      : super(key: key);

  final String label;
  final Color backgroundColor;
  final Color color;
  final Function onPressed;
  final bool loading;
  final bool outlined;
  final bool enabled;

  @override
  _StyledColoredButtonState createState() => _StyledColoredButtonState();
}

class _StyledColoredButtonState extends State<StyledColoredButton> {
  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: double.infinity,
      height: 55,
      alignment: AlignmentDirectional(0, 0),
      child: widget.loading
          ? SpinKitRing(
              color: widget.color,
              size: 18,
              lineWidth: 2,
            )
          : Text(
              widget.label,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 22),
            ),
    );

    final color = this.widget.backgroundColor ?? Theme.of(context).accentColor;
    final shape =
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10));
    final onPressed = widget.enabled ? widget.onPressed : null;

    return widget.outlined
        ? OutlineButton(
            onPressed: onPressed,
            color: color,
            shape: shape,
            textColor: widget.color,
            child: child,
          )
        : FlatButton(
            onPressed: onPressed,
            color: color,
            textColor: widget.color,
            shape: shape,
            child: child,
            disabledColor: Colors.blueGrey,
            disabledTextColor: Colors.white,
          );
  }
}
