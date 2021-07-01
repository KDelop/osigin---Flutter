import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mca_driver_app/models/dto/mca_sails/order_status.dart';
import 'package:mca_driver_app/models/notification.dart';

import '../models/notification.dart';

/// Wrapper around hive.
/// TODO, make it abstracted even more, remove the Box and expose a
///
///     set(key, val)
///     delete(key, val)
///
/// while also making this class specific to the data type its saving.
class HiveRepository {
  bool _initialized = false;
  bool _initializing = false;

  void initialize() async {
    if (_initialized || _initializing) {
      return;
    }

    _initializing = true;

    try {
      await Hive.initFlutter();

      // Have to register subclasses before parent classes
      Hive.registerAdapter(OrderAssignedNotificationAdapter());
      Hive.registerAdapter(OrderCanceledNotificationAdapter());
      Hive.registerAdapter(AppNotificationAdapter());
      Hive.registerAdapter(OrderStatusAdapter());
    } finally {
      _initialized = true;
      _initializing = false;
    }
  }

  Future<Box<AppNotification>> getNotificationBox() async {
    if (!_initialized) {
      await initialize();
    }

    return Hive.openBox<AppNotification>('notification_box');
  }
}
