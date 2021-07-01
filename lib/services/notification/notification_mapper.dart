import '../../models/dto/push_notification/order_assigned_notification_dto.dart';
import 'package:uuid/uuid.dart';

import '../../models/dto/push_notification/order_canceled_notification_dto.dart';

import '../../models/dto/push_notification/notification_dto.dart';

import '../../models/notification.dart';

/// Converts notifications from the server into the app model for storage/view
class NotificationMapper {
  NotificationMapper();

  OrderAssignedNotification _mapOrderAssignedNotification(
      OrderAssignedNotificationDto dto) {
    return OrderAssignedNotification()
      ..id = Uuid().v4().toString()
      ..orderId = dto.orderId
      ..message = dto.message;
  }

  OrderCanceledNotification _mapOrderCanceledNotification(
      OrderCanceledNotificationDto dto) {
    return OrderCanceledNotification()
      ..id = Uuid().v4().toString()
      ..orderId = dto.orderId
      ..message = dto.message;
  }

  _mapToAppNotificationDto(NotificationDto dto) {
    return AppNotification()
      ..id = Uuid().v4().toString()
      ..message = dto.message
      ..date = DateTime.now();
  }

  AppNotification mapToNotification(NotificationDto notificationDto) {
    switch (notificationDto.runtimeType) {
      case OrderAssignedNotificationDto:
        return _mapOrderAssignedNotification(notificationDto);
      case OrderCanceledNotificationDto:
        return _mapOrderCanceledNotification(notificationDto);
      default:
        return _mapToAppNotificationDto(notificationDto);
    }
  }
}
