import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_driver_app/models/notification.dart';

class PendingOrderAssignmentTile extends StatelessWidget {
  final GestureTapCallback _onTap;
  final ConfirmDismissCallback _onDismissed;

  final OrderAssignedNotification notification;

  PendingOrderAssignmentTile(this.notification,
      {GestureTapCallback onTap, ConfirmDismissCallback onDismissed})
      : _onTap = onTap,
        _onDismissed = onDismissed;

  _getIcon() {
    const size = 40.0;
    return Icon(Icons.map, size: size);
  }

  _getDateString() {
    return DateFormat('MM/d').format(notification.date);
  }

  _getTimeString() {
    return DateFormat.jm().format(notification.date);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(notification.id),
      onDismissed: _onDismissed,
      child: Card(
          child: ListTile(
              leading: _getIcon(),
              trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(_getDateString()), Text(_getTimeString())]),
              title: Text(notification.message),
              onTap: _onTap)),
    );
  }
}
