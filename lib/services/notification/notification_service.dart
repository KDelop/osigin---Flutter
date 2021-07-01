import 'package:mca_driver_app/services/push_notification/pushy_service.dart';
import 'package:uuid/uuid.dart';

import '../order_service.dart';

import '../navigation_service.dart';
import '../overlay_service.dart';

import '../../models/dto/push_notification/notification_dto.dart';

import '../../models/notification.dart';
import '../../repo/hive_repository.dart';
import 'package:rxdart/rxdart.dart';

import '../service_locator.dart';
import 'notification_mapper.dart';

class NotificationService {
  final NotificationMapper _notifMapper;
  final HiveRepository _hiveRepo;
  final OverlayService _overlayService;
  final NavigationService _navigationService;
  final OrderService _orderService;

  NotificationService(this._notifMapper, this._hiveRepo, this._overlayService,
      this._navigationService, this._orderService) {
    // Update when orderService does something good
    _orderService.getOrderResponseStream().listen((orderId) {
      _getServerListOrders();
    });

    _publishList();
  }

  final BehaviorSubject<List<AppNotification>> _notificationListBs =
      BehaviorSubject<List<AppNotification>>.seeded([]);

  Observable<List<AppNotification>> getNotifications() {
    return _notificationListBs.stream;
  }

  Future<void> addNotification(NotificationDto notification) async {
    var appNotification = await _notifMapper.mapToNotification(notification);

    _handleNotification(appNotification);

    var box = await _hiveRepo.getNotificationBox();
    await box.put(appNotification.id, appNotification);

    _publishList();

    _getServerListOrders();
  }

  Future<void> removeNotification(String uuid) async {
    var box = await _hiveRepo.getNotificationBox();
    await box.delete(uuid);
    _publishList();
  }

  Future<void> refreshFromServer() {
    return _getServerListOrders();
  }

  // Todo, this is nuts.  Needs to be refactored.
  // Doesn't handle notifications with duplicate order ids
  Future<void> _getServerListOrders() async {
    // Get our local order assigned notifications
    // along with server notifications.

    var pendingOrders =
        await _orderService.getPendingOrderAssignedNotifications();
    var box = await _hiveRepo.getNotificationBox();

    var localNotifications = box.values.whereType<OrderAssignedNotification>();

    // Figure out the operations

    var localOrderIds =
        Set<String>.from(localNotifications.map((n) => n.orderId));

    var serverOrderIds = Set<String>.from(pendingOrders.map((n) => n.orderId));

    var toAdd = serverOrderIds.difference(localOrderIds);
    var toDelete = localOrderIds.difference(serverOrderIds);
    var toUpdate = localOrderIds.intersection(serverOrderIds);

    // Update op
    for (var updateId in toUpdate) {
      var updateOrder =
          pendingOrders.firstWhere((element) => element.orderId == updateId);
      var noteOrder = localNotifications
          .firstWhere((element) => element.orderId == updateId);

      updateOrder.id = noteOrder.id;

      box.put(updateOrder.id, updateOrder);
    }

    // Add operations
    for (var addId in toAdd) {
      var updateOrder =
          pendingOrders.firstWhere((element) => element.orderId == addId);
      updateOrder.id = Uuid().v4().toString();

      box.put(updateOrder.id, updateOrder);
    }

    // Delete operations
    for (var deleteId in toDelete) {
      var deleteOrders =
          localNotifications.where((element) => element.orderId == deleteId);

      for (var deleteOrder in deleteOrders) {
        box.delete(deleteOrder.id);
      }
    }

    _publishList();
  }

  _handleNotification(AppNotification notif) {
    _overlayService.setNotification(
        notif.message, _navigationService.showNotificationCenter);
  }

  _publishList() async {
    var box = await _hiveRepo.getNotificationBox();
    var notificationList = box.values.toList();

    if (notificationList.length == 0) {
      sl.get<PushyService>().clearIOSBadge();
    }

    _notificationListBs.add(notificationList);
  }
}
