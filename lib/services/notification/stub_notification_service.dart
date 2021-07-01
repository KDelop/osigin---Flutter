import 'package:mca_driver_app/services/notification/notification_service.dart';

import '../order_service.dart';

import '../navigation_service.dart';
import '../overlay_service.dart';

import '../../models/dto/push_notification/notification_dto.dart';

import '../../models/notification.dart';
import '../../repo/hive_repository.dart';
import 'package:rxdart/rxdart.dart';

import 'notification_mapper.dart';

///
/// Attempt at a 'stub' that doesn't do anything with notifications except
/// manage the in-app indicator and also manage a count for the bottom app bar.
/// Currently using the old StubNotificationService in a scheme that queries
/// the server for notifications.
///
/// TODO: Decide whether to keep going with that scheme or drop it for something
/// like this
///
class StubNotificationService implements NotificationService {
  final NotificationMapper _notifMapper;
  final HiveRepository _hiveRepo;
  final OverlayService _overlayService;
  final NavigationService _navigationService;
  final OrderService _orderService;

  StubNotificationService(this._notifMapper, this._hiveRepo,
      this._overlayService, this._navigationService, this._orderService) {
    _publishList();
  }

  final BehaviorSubject<List<AppNotification>> _notificationListBs =
      BehaviorSubject<List<AppNotification>>.seeded([]);

  Observable<List<AppNotification>> getNotifications() {
    return _notificationListBs.stream;
  }

  Future<void> addNotification(NotificationDto dto) async {
    var notification = _notifMapper.mapToNotification(dto);
    _handleNotification(notification);
    _update();
  }

  Future<void> removeNotification(String uuid) async {
    throw Exception("Not Impl.");
  }

  // TODO !! DEBOUNCE!
  _update() async {
    var pendingOrders = await _orderService.getOrdersPendingConfirmation();

    var pending = pendingOrders
        .map((o) =>
            AppNotification()..message = "Order ${o.orderNumber} ${o.status}")
        .toList();

    _notificationListBs.add(pending);
  }

  _handleNotification(AppNotification notif) {
    _overlayService.setNotification(
        notif.message, _navigationService.showNotificationCenter);
  }

  _publishList() async {
    var box = await _hiveRepo.getNotificationBox();
    _notificationListBs.add(box.values.toList());
  }

  @override
  Future<void> refreshFromServer() {
    // TODO: implement refreshFromServer
    throw UnimplementedError();
  }
}
