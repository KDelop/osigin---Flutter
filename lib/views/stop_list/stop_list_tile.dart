import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mca_driver_app/constants/assets.dart';
import 'package:mca_driver_app/models/dto/mca_sails/stop_list_item_dto.dart';
import '../../models/stop_stage.dart';
import '../../models/stop_type.dart';

class StopListTile extends StatelessWidget {
  final GestureTapCallback onTap;
  final StopListItemDto model;

  const StopListTile({@required this.model, this.onTap, Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
          leading: _getIcon(),
          trailing: model.isTimeAsap
              ? Text("Today")
              : Text(DateFormat.jm().format(model.scheduledTime)),
          title: Text(model.locationName),
          subtitle: Text(model.locationShortAddress),
          onTap: onTap),
    );
  }

  _getIcon() {
    const size = 40.0;

    switch (model.stopStatus) {
      case StopStage.ready:
        return _getStopTypeIcon(model.stopType);
      case StopStage.complete:
        return StopIconWidget(AppAssets.checkArrowIcon, size: 32);
      case StopStage.confirm:
        return _getStopTypeIcon(model.stopType);
    }
  }

  // IconData _getStopTypeIcon(StopType type) {
  //   switch (type) {
  //     case StopType.pickup:
  //       return Icons.arrow_upward;
  //     case StopType.dropoff:
  //       return Icons.arrow_downward;
  //   }
  //
  //   return Icons.ac_unit;
  // }

  Widget _getStopTypeIcon(StopType type) {
    switch (type) {
      case StopType.pickup:
        return StopIconWidget(AppAssets.upArrowIcon);
      case StopType.dropoff:
        return StopIconWidget(AppAssets.downArrowIcon);
    }

    return Icon(Icons.ac_unit);
  }
}

class StopIconWidget extends StatelessWidget {
  final String source;
  final double size;
  StopIconWidget(
    this.source, {
    this.size = 36.0,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      source,
      width: size,
      fit: BoxFit.contain,
    );
  }
}
