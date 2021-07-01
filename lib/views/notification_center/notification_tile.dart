import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/notification.dart';

class NotificationTile extends StatelessWidget {
  final GestureTapCallback _onTap;
  final ConfirmDismissCallback _onDismissed;

  final AppNotification notification;

  NotificationTile(this.notification,
      {GestureTapCallback onTap, ConfirmDismissCallback onDismissed})
      : _onTap = onTap, _onDismissed = onDismissed;

  _getIcon() {
    const size = 40.0;
    return Icon(Icons.notifications, size: size);
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
