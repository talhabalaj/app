import 'package:flutter/material.dart';

import '../constants.dart';

class ButtonSeparator extends StatelessWidget {
  const ButtonSeparator({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Positioned(
            child: Divider(),
          ),
          Container(
            alignment: Alignment.center,
            child: Text(
              "OR",
              style: kTextStyle.copyWith(
                fontSize: 20,
                color: Colors.grey,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
