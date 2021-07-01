import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_driver_app/models/dto/mca_sails/order_detail_dto.dart';

class OrderListTile extends StatelessWidget {
  final GestureTapCallback onTap;
  final OrderDetailDto model;

  const OrderListTile({@required this.model, this.onTap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: _getIcon(),
        trailing: _getTrailing(),
        title: Text(model.name),
        onTap: onTap);
  }

  _getTrailing() {
    if (model.scheduledDate == null) {
      return null;
    }

    return Text(DateFormat("M/d/yy\nh:mm a").format(model.scheduledDate));
  }

  _getIcon() {
    const size = 40.0;
    return Icon(Icons.description_outlined, size: size);
  }
}
