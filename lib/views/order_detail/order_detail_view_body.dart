import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_driver_app/models/dto/mca_sails/order_detail_dto.dart';
import 'package:mca_driver_app/models/dto/mca_sails/stop_list_item_dto.dart';
import '../../models/dto/mca_sails/order_status.dart';
import 'order_assignment_status_tile.dart';
import 'order_detail_confirm_tile.dart';
import 'order_detail_header.dart';
import '../stop_detail/requirements_list_tile.dart';
import '../stop_list/stop_list_tile.dart';

typedef StopTapHandler = void Function(String id);

class OrderDetailViewBody extends StatelessWidget {
  final OrderDetailDto model;

  final Function onConfirm;
  final Function onReject;
  final StopTapHandler onStopTap;

  const OrderDetailViewBody(
      {@required this.model,
      @required this.onConfirm,
      @required this.onReject,
      @required this.onStopTap,
      key})
      : super(key: key);

  String _getDate() {
    return DateFormat("MM / dd / yyyy").format(model.scheduledDate);
  }

  Widget _getOrderDetailConfirmTile() {
    switch (model.status) {
      case OrderStatus.assigned:
        return OrderDetailConfirmTile(
          onConfirm: onConfirm,
          onReject: onReject,
        );
      default:
        return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: [
              OrderDetailHeader(
                orderNumber: model.orderNumber,
              ),
              _getOrderDetailConfirmTile(),
              ListTile(
                leading: Icon(Icons.calendar_today),
                title: Text(_getDate()),
                subtitle: Text('Scheduled Date'),
              ),
              model.clientName != ""
                  ? ListTile(
                      leading: Icon(Icons.person_outline),
                      title: Text(model.clientName),
                      subtitle: Text("Client"),
                    )
                  : Text(""),
              RequirementsListTile(
                requirements: model.requiredCerts + model.requiredEquipment,
              ),
              OrderAssignmentStatusTile(orderStatus: model.status),
              Divider(),
              Container(
                child: Text('Stops', style: TextStyle(fontSize: 20)),
                margin: EdgeInsets.symmetric(horizontal: 20),
              ),
            ] +
            _getStopTiles(model.stops));

    // return _roid();

    // return Container(
    //     child: Column(
    //   children: [
    //     Container(
    //       child: Text('foo'),
    //       color: Colors.red,
    //     ),
    //     Spacer(),
    //     Container(
    //         color: Colors.green,
    //         constraints: BoxConstraints.expand(height: 100),
    //         child: Text('1')),
    //   ],
    // )

    // RequirementsCard(label: 'Required Certifications', items: ['bar']),
    // RequirementsCard(label: 'Required Equipment', items: ['bar']),
    // Container(
    //   margin: EdgeInsets.only(left: 60, right: 60),
    //   child: RaisedButton(
    //     color: Colors.green,
    //     onPressed: () => {},
    //     child: Text('stage', style: TextStyle(fontSize: 20)),
    //   ),
    // ),
    // true
    //     ? Container(
    //         margin: EdgeInsets.only(left: 60, right: 60),
    //         child: RaisedButton(
    //           color: Colors.red,
    //           onPressed: () => {},
    //           child: Text("Reject Delivery", style: TextStyle(fontSize: 20)),
    //         ),
    //       )
    //     : Text('')
    // );
  }

  List<Widget> _getStopTiles(List<StopListItemDto> stops) {
    if (stops.length == 0) {
      return [ListTile(title: Text('No Stops'))];
    }

    var tiles = stops.map((stop) {
      return StopListTile(
        model: stop,
        onTap: () {
          onStopTap(stop.stopId);
        },
      );
    }).toList();

    return tiles;
  }
}
