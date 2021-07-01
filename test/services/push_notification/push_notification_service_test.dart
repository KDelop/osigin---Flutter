import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/models/dto/push_notification/notification_dto.dart';
import 'package:mca_driver_app/models/dto/push_notification/order_assigned_notification_dto.dart';
import 'package:mca_driver_app/models/dto/push_notification/order_canceled_notification_dto.dart';
import 'package:mca_driver_app/services/push_notification/push_notification_service.dart';
import 'package:mca_driver_app/services/push_notification/pushy_service.dart';
import 'package:mockito/mockito.dart';
import 'package:rxdart/rxdart.dart';

class MockPushyService extends Mock implements PushyService {}

void main() {
  PushyService pushySvc;
  PublishSubject<Map<String, dynamic>> notifPublishSubject;

  PushNotificationService pushNotifSvc;

  group('PushNotificationService', () {
    setUp(() {
      notifPublishSubject = PublishSubject<Map<String, dynamic>>();

      pushySvc = MockPushyService();
      when(pushySvc.notificationStream)
          .thenAnswer((_) => notifPublishSubject.stream);

      pushNotifSvc = PushNotificationService(pushySvc);
    });

    test('is broadcast stream', () {
      pushNotifSvc.notifications.listen((_) {}).cancel();
      pushNotifSvc.notifications.listen((_) {});
    });

    test(
        'OrderAssigned are emitted as '
        'OrderAssignedNotificationDto', () async {
      expectLater(pushNotifSvc.notifications,
          emits(OrderAssignedNotificationDto("anything-here", "test-rder-id")));

      notifPublishSubject.add({
        "orderId": "test-rder-id",
        "type": "OrderAssigned",
        "message": "anything-here"
      });
    });

    test(
        'OrderCanceled is emitted as '
        'OrderCanceledNotificationDto', () async {
      expectLater(
          pushNotifSvc.notifications,
          emits(OrderCanceledNotificationDto(
              "Some cancelation message", "orderId!!")));

      notifPublishSubject.add({
        "orderId": "orderId!!",
        "type": "OrderCanceled",
        "message": "Some cancelation message"
      });
    });

    test(
        'Unspecified type is emitted as '
        'NotificationDto', () async {
      expectLater(pushNotifSvc.notifications,
          emits(NotificationDto("whatever", "Future notification!")));

      notifPublishSubject
          .add({"type": "whatever", "message": "Future notification!"});
    });

    test('canceling should queue the messages again', () async {
      var vals = [];
      var sub = pushNotifSvc.notifications.listen((d) => vals.add(d));

      await Future.delayed(Duration(milliseconds: 1));

      expect(vals.length, equals(0));
      sub.cancel();

      notifPublishSubject.add({
        "payload": json.encode({"deliveryId": "deliveryId1"}),
        "type": "Notification!!!",
        "message": "one"
      });

      notifPublishSubject.add({
        "payload": json.encode({"deliveryId": "deliveryId2"}),
        "type": "Notification!!!",
        "message": "two"
      });

      notifPublishSubject.add({
        "payload": json.encode({"deliveryId": "deliveryId3"}),
        "type": "Notification!!!",
        "message": "three"
      });

      expect(
          pushNotifSvc.notifications,
          emitsInOrder([
            NotificationDto("Notification!!!", "one"),
            NotificationDto("Notification!!!", "two"),
            NotificationDto("Notification!!!", "three"),
          ]));
    });
  });
}
