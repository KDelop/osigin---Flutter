import '../services/notification/notification_service.dart';

import '../models/notification.dart';

import 'package:rxdart/rxdart.dart';

class NotificationCenterStore {
  Observable<List<AppNotification>> get notifications {
    return _notificationService.getNotifications();
  }

  final NotificationService _notificationService;

  NotificationCenterStore(this._notificationService);

  void handleItemDismissal(String id) async {
    await _notificationService.removeNotification(id);
  }

  Future<void> handleRefresh() async {
    await _notificationService.refreshFromServer();
  }
}
