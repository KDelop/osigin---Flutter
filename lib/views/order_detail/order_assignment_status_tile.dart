import 'package:flutter/material.dart';
import '../../models/dto/mca_sails/order_status.dart';

class OrderAssignmentStatusTile extends StatelessWidget {
  final OrderStatus orderStatus;

  const OrderAssignmentStatusTile({this.orderStatus, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(Icons.badge), title: Text(_getText()));
  }

  _getText() {
    switch (orderStatus) {
      case OrderStatus.created:
        return 'Order Unassigned';
        break;
      case OrderStatus.assigned:
        return 'Pending Your Confirmation';
        break;
      case OrderStatus.rejected:
        return 'Rejected by Driver';
        break;
      case OrderStatus.accepted:
        return 'Accepted by Driver';
        break;
      case OrderStatus.inprogress:
        return 'Accepted by Driver';
        break;
      case OrderStatus.complete:
        break;
      case OrderStatus.canceled:
        return 'Order cancelled';
        break;
      case OrderStatus.invoiced:
        return 'Accepted by Driver';
        break;
    }
  }
}
