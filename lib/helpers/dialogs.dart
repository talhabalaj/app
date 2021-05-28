import 'package:Moody/models/error_response_model.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

Future showErrorDialog({BuildContext context, WebErrorResponse e}) {
  print(e.code);
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(e.message),
      contentTextStyle: kTextStyle,
      title: Text(e.type),
      actions: <Widget>[
        TextButton(
          child: Text("Close"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    ),
  );
}

Future<bool> showConfirmationDialog(
    {@required BuildContext context, String title, String desc}) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(desc),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text('Yes'),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text('No'),
        ),
      ],
    ),
  );
}
