import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../../models/stop_stage.dart';
import '../../models/data_status.dart';
import '../../models/stop_detail_vm.dart';
import '../../models/stop_type.dart';
import '../../services/service_locator.dart';
import '../../stores/stop_detail_store.dart';
import '../common/data_status_container.dart';
import '../common/scaffold_builder.dart';
import 'stop_detail_body.dart';

class StopDetailView extends HookWidget {
  const StopDetailView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var store = sl.get<StopDetailStore>();
    var scaffoldBuilder = sl.get<ScaffoldBuilder>();

    var model = useStream(store.model).data ?? StopDetailVm();

    var dataStatus = useStream(store.modelStatus).data ?? DataStatus.loading;

    var showFab = dataStatus == DataStatus.loaded &&
        (model.data.stopStatus != StopStage.complete);

    String _getButtonText() {
      switch (model.data.stopType) {
        case StopType.pickup:
          return "Start Pickup";
        case StopType.dropoff:
          return "Start Dropoff";
      }

      return '';
    }

    return scaffoldBuilder.build(
      showDrawer: false,
      title: _getAppBarLabel(model, dataStatus),
      floatingActionButton: showFab
          ? FloatingActionButton.extended(
              onPressed: () {
                store.handleFabPress();
              },
              label: Text(_getButtonText()),
              backgroundColor: Colors.green,
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      child: DataStatusContainer(
        dataStatus: dataStatus,
        child: StopDetailBody(model: model),
      ),
    );
  }

  _getAppBarLabel(StopDetailVm model, DataStatus dataStatus) {
    // var isLoading = model == null;
    //
    // return isLoading
    //     ? "Loading Stop... "
    //     : "Stop at ${model.data.locationName}";

    return dataStatus == DataStatus.loading
        ? "Loading Stop... "
        : "Stop at ${model.data.locationName}";
  }
}
