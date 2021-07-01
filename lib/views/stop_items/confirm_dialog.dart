
import 'package:flutter/material.dart';
import 'items_view_mode.dart';

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog(this.mode, {@required this.onConfirm});

  final ItemsViewMode mode;
  final Function onConfirm;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          mode == ItemsViewMode.pickup ? 'Confirm Pickup' : 'Confirm Dropoff'),
      content: Text('Are all items accounted for?'),
      actions: <Widget>[
        FlatButton(
          child: const Text('CANCEL'),
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
        ),
        FlatButton(
          child: const Text('CONFIRM'),
          onPressed: () {
            onConfirm();
            Navigator.of(context, rootNavigator: true).pop();
          },
        )
      ],
    );
  }
}