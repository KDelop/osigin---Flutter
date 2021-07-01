import 'dart:async';

import 'notification_service.dart';
import '../push_notification/push_notification_service.dart';

/// Connects push notifications to the Notification Service
/// Useful for login/logoff.
class PushNotificationConnector {
  final PushNotificationService _pushSvc;
  final NotificationService _notificationSvc;
  StreamSubscription _subscription;

  PushNotificationConnector(this._pushSvc, this._notificationSvc);

  void connect() {
    _subscription =
        _pushSvc.notifications.listen(_notificationSvc.addNotification);

    _notificationSvc.refreshFromServer();
  }

  void disconnect() {
    if (_subscription == null) {
      return;
    }

    _subscription.cancel();
  }
}
