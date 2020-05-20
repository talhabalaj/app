import 'package:Moody/models/error_response_model.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

Future showErrorDialog({BuildContext context, WebErrorResponse e}) {
  print(e.code);
  return showDialog(
    context: context,
    child: AlertDialog(
      content: Text(e.message),
      contentTextStyle: kTextStyle,
      title: Text(e.type),
      actions: <Widget>[
        FlatButton(
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
    child: AlertDialog(
      title: Text(title),
      content: Text(desc),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text('Yes'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text('No'),
        ),
      ],
    ),
  );
}
