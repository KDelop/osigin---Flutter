import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mca_driver_app/any.dart';
import 'package:mca_driver_app/models/dto/mca_sails/order_detail_dto.dart';
import 'package:mca_driver_app/models/dto/mca_sails/order_status.dart';
import 'package:mca_driver_app/models/dto/push_notification/order_assigned_notification_dto.dart';
import 'package:mca_driver_app/models/notification.dart';
import 'package:mca_driver_app/repo/hive_repository.dart';
import 'package:mca_driver_app/services/navigation_service.dart';
import 'package:mca_driver_app/services/notification/notification_mapper.dart';
import 'package:mca_driver_app/services/notification/notification_service.dart';
import 'package:mca_driver_app/services/order_service.dart';
import 'package:mca_driver_app/services/overlay_service.dart';
import 'package:mockito/mockito.dart';

class MockNotificationMapper extends Mock implements NotificationMapper {}

class MockHiveRepository extends Mock implements HiveRepository {}

class MockBox<AppNotification> extends Mock implements Box<AppNotification> {}

class MockNavigationService extends Mock implements NavigationService {}

class MockOverlayService extends Mock implements OverlayService {}

class MockOrderService extends Mock implements OrderService {}

void main() {
  NotificationService notificationService;
  NotificationMapper notificationMapper;
  NavigationService navigationService;
  OverlayService overlayService;
  OrderService orderService;
  HiveRepository hiveRepository;
  Box<AppNotification> box;

  AppNotification testMappedAppNotification;

  // TODO: No tests for the complicated piece hiding in here related to
  // grabbing pending orders and reconciling them with our stored notifs.
  group('NotificationService AddNotification', () {
    setUpAll(() {
      box = MockBox();
      hiveRepository = MockHiveRepository();
      overlayService = MockOverlayService();
      navigationService = MockNavigationService();
      orderService = MockOrderService();

      when(orderService.getOrderResponseStream())
          .thenAnswer((realInvocation) => Stream.fromIterable([]));

      when(orderService.getPendingOrderAssignedNotifications())
          .thenAnswer((realInvocation) async {
        return [];
      });

      when(hiveRepository.getNotificationBox()).thenAnswer((_) async {
        return box;
      });

      when(box.values).thenReturn([appNotification()]);

      notificationMapper = MockNotificationMapper();
      notificationService = NotificationService(notificationMapper,
          hiveRepository, overlayService, navigationService, orderService);

      testMappedAppNotification = appNotification();
      when(notificationMapper.mapToNotification(any)).thenAnswer((_) {
        return testMappedAppNotification;
      });
    });

    test('addNotification', () async {
      var notificationDto =
          OrderAssignedNotificationDto('guid', 'You have been assigned!');

      // It should emit the current box notifications
      var stream = notificationService.getNotifications();
      expect(stream, emits(box.values));

      // Eventually should emit the values a second time after the notification
      // is added.
      expectLater(stream, emitsInOrder([box.values, box.values]));

      await notificationService.addNotification(notificationDto);

      verify(notificationMapper.mapToNotification(notificationDto));

      verify(box.put(testMappedAppNotification.id, testMappedAppNotification));
    });

    // TODO: what happened here?
    test('addNotification2', () async {
      var notificationDto =
          OrderAssignedNotificationDto('you have been assigned', guid());

      // It should emit the current box notifications
      var stream = notificationService.getNotifications();
      expect(stream, emits(box.values));

      // Eventually should emit the values a second time after the notification
      // is added.
      expectLater(stream, emitsInOrder([box.values, box.values]));

      when(orderService.getOrdersPendingConfirmation()).thenAnswer((_) async {
        return [
          OrderDetailDto()..id = notificationDto.orderId,
          OrderDetailDto()
            ..id = guid()
            ..name = "Route x"
            ..orderNumber = "232"
            ..status = OrderStatus.assigned
        ];
      });

      await notificationService.addNotification(notificationDto);

      verify(notificationMapper.mapToNotification(notificationDto));

      // verify(orderService.getOrdersPendingConfirmation());

      verify(box.put(testMappedAppNotification.id, testMappedAppNotification));
    });

    test('removeNotification', () async {
      var next = 'someguid';

      await notificationService.removeNotification(next);

      verify(box.delete(next));

      expectLater(notificationService.getNotifications(),
          emitsInOrder([box.values, box.values]));
    });
  });
}
