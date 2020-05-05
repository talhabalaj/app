import 'package:app/models/error_response_model.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

Future showErrorDialog({BuildContext context, WebApiErrorResponse e}) {
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
