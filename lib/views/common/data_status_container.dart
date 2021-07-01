import 'package:flutter/material.dart';
import '../../models/data_status.dart';

class DataStatusContainer extends StatelessWidget {
  final DataStatus dataStatus;
  final Widget child;

  const DataStatusContainer({@required this.dataStatus, this.child});

  @override
  Widget build(BuildContext context) {
    switch (dataStatus) {
      case DataStatus.loading:
        return Center(child: Container(child: CircularProgressIndicator()));

      case DataStatus.loaded:
        return child;

      case DataStatus.notFound:
        return Center(child: Text("Not Found"));

      default:
        // and error
        return Center(child: Text("There was an error..."));
    }
  }
}
