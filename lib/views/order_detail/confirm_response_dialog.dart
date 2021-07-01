import 'package:flutter/material.dart';

class ConfirmResponseDialog extends StatelessWidget {
  const ConfirmResponseDialog(
      {@required this.title,
      @required this.actionText,
      @required this.onConfirm});

  final Function onConfirm;
  final String title;
  final String actionText;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      actions: <Widget>[
        FlatButton(
          child: const Text('Go Back'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        FlatButton(
          child: Text(actionText),
          onPressed: () {
            onConfirm();
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    );
  }
}
