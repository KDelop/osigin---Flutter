
import 'package:flutter/material.dart';
import '../../labels.dart';

class PickupPointsWallDialog extends StatelessWidget {

  const PickupPointsWallDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(UiLabels.pickupPointsWallDialogTitle),
      content: Text(UiLabels.pickupPointsWallDialogBody),
      actions: <Widget>[
        FlatButton(
          child: const Text('OK'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
      ],
    );
  }
}