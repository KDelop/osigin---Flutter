import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_driver_app/constants/assets.dart';
import 'package:mca_driver_app/views/stop_list/stop_list_tile.dart';
import '../../models/stop_stage.dart';
import '../../models/stop_type.dart';
import '../../models/stop_detail_vm.dart';
import 'requirements_list_tile.dart';
import 'special_instructions_box.dart';

import 'address_list_tile.dart';
import 'site_contact_list_tile.dart';

class StopDetailBody extends StatelessWidget {
  const StopDetailBody({this.model, Key key}) : super(key: key);

  final StopDetailVm model;

  // _getIcon() {
  //   if (model.data.stopStatus == StopStage.complete) {
  //     return Icons.check;
  //   }
  //
  //   if (model.data.stopStatus == StopType.pickup) {
  //     return Icons.arrow_upward;
  //   } else {
  //     return Icons.arrow_downward;
  //   }
  // }

  Widget _getIcon() {
    if (model.data.stopStatus == StopStage.complete) {
      return StopIconWidget(
        AppAssets.checkArrowIcon,
        size: 56,
      );
    }

    if (model.data.stopType == StopType.pickup) {
      return StopIconWidget(
        AppAssets.upArrowIcon,
        size: 56.0,
      );
    } else {
      return StopIconWidget(
        AppAssets.downArrowIcon,
        size: 56.0,
      );
    }
  }

  String _getCompletionLabel() {
    if (model.data.stopType == StopType.pickup) {
      return "Pickup Completed";
    } else {
      return "Dropoff Completed";
    }
  }

  String _getLoadLabel() {
    if (model.data.stopStatus == StopStage.complete) {
      return _getCompletionLabel();
    }

    if (model.data.stopType == StopType.pickup) {
      return "Pickup at ${DateFormat.jm().format(model.data.scheduledTime)}";
    } else {
      return "Dropoff at ${DateFormat.jm().format(model.data.scheduledTime)}";
    }
  }

  @override
  Widget build(BuildContext context) {
    print(model.data.stopType);

    return Column(
      children: <Widget>[
        //
        Container(
          margin: EdgeInsets.all(20),
          child: Row(
            children: <Widget>[
              _getIcon(),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      _getLoadLabel(),
                      style: TextStyle(fontSize: 28),
                    ),
                    Text(
                      model.data.locationName,
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(),
        (model.data.orderInstructions != '' ||
                model.data.clientInstructions != '' ||
                model.data.locationInstructions != '' ||
                model.data.stopInstructions != '')
            ? SpecialInstructionsBox(
                stop: model.data.stopInstructions,
                order: model.data.orderInstructions,
                location: model.data.locationInstructions,
                client: model.data.clientInstructions,
              )
            : null,
        AddressListTile(address: model.data.locationAddress),
        SiteContactListTile(
          phone: model.data.locationContactPhone,
          name: model.data.locationContactName,
        ),
        RequirementsListTile(
          requirements: model.data.requiredEquipment + model.data.requiredCerts,
        ),
        model.data.isPartOfRoute
            ? ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Route: ${model.data.orderName}'),
              )
            : null,
      ].where((i) => i != null).toList(),
    );
  }
}
