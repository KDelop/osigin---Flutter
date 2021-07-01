import 'package:flutter/material.dart';
import 'package:mca_driver_app/views/order_list/order_list_tile.dart';
import '../../models/notification.dart';

class OrderAssignedNotificationTile extends StatelessWidget {
  final GestureTapCallback _onTap;

  final OrderAssignedNotification notification;

  OrderAssignedNotificationTile(this.notification, {GestureTapCallback onTap})
      : _onTap = onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
        child: OrderListTile(
            onTap: _onTap, model: notification.toOrderDetailDto()));
  }
}
