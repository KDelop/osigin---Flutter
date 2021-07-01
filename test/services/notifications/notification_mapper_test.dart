import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/models/dto/push_notification/notification_dto.dart';
import 'package:mca_driver_app/models/dto/push_notification/order_assigned_notification_dto.dart';
import 'package:mca_driver_app/models/dto/push_notification/order_canceled_notification_dto.dart';
import 'package:mca_driver_app/models/notification.dart';
import 'package:mca_driver_app/services/notification/notification_mapper.dart';

void main() {
  group('NotificationMapper', () {
    NotificationMapper notificationMapper;

    setUp(() {
      notificationMapper = NotificationMapper();
    });

    test('maps notificationDto', () async {
      var pushDto = NotificationDto("anything", "some meessage");

      var result = await notificationMapper.mapToNotification(pushDto);

      expect(result, isA<AppNotification>());

      expect(result.message, equals('some meessage'));
    });

    test('maps OrderAssignedDto', () async {
      var pushDto = OrderAssignedNotificationDto("Order Assigned!", "some-id");

      var result = await notificationMapper.mapToNotification(pushDto);

      expect(result, isA<OrderAssignedNotification>());

      var notification = result as OrderAssignedNotification;

      expect(notification.message, equals('Order Assigned!'));
      expect(notification.orderId, equals("some-id"));
    });

    test('maps DeliveryCanceledDto', () async {
      var pushDto = OrderCanceledNotificationDto('deliveryId', 'msg!');
      var result = await notificationMapper.mapToNotification(pushDto);

      expect(result, isA<OrderCanceledNotification>());

      var canceledNotif = result as OrderCanceledNotification;
      expect(canceledNotif.orderId, equals(pushDto.orderId));
      expect(canceledNotif.message, equals(pushDto.message));
    });
  });
}
