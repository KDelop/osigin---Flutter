import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'delivery_canceled_notification_tile.dart';
import '../../models/notification.dart';
import '../../services/navigation_service.dart';
import '../../services/service_locator.dart';
import '../../stores/notification_center_store.dart';
import '../common/mca_scaffold.dart';
import 'order_assigned_notification_tile.dart';
import 'notification_tile.dart';

class NotificationCenterView extends HookWidget {
  const NotificationCenterView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = sl.get<NotificationCenterStore>();

    var notifications = useStream(store.notifications).data ?? [];

    return Container(
      child: McaScaffold(
          title: "Notifications",
          showBottomNav: true,
          child: RefreshIndicator(
              onRefresh: store.handleRefresh, child: _getBody(notifications))),
    );
  }

  _getBody(List<AppNotification> notifications) {
    if (notifications.isEmpty) {
      return ListView(children: [
        Container(
            margin: EdgeInsets.all(10),
            child: Center(child: Text('You have no notifications')))
      ]);
    }
    var store = sl.get<NotificationCenterStore>();
    var navSvc = sl.get<NavigationService>();

    return ListView(
        children: notifications
            .map((notif) {
              switch (notif.runtimeType) {
                case (OrderAssignedNotification):
                  return OrderAssignedNotificationTile(notif, onTap: () {
                    navSvc.showOrderDetail(
                        (notif as OrderAssignedNotification).orderId);
                  });

                case (OrderCanceledNotification):
                  var cancelNotif = notif as OrderCanceledNotification;
                  return DeliveryCanceledNotificationTile(notif,
                      onDismissed: (_) async {
                    store.handleItemDismissal(notif.id);
                    return true;
                  }, onTap: () {
                    navSvc.showOrderDetail(cancelNotif.orderId);
                  });

                default:
                  return NotificationTile(
                    notif,
                    onDismissed: (_) async {
                      store.handleItemDismissal(notif.id);
                      return true;
                    },
                  );
              }
            })
            .where((v) => v != null)
            .toList());
  }
}
