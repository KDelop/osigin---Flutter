import 'package:mca_driver_app/services/stop_service/memory_stop_service.dart';

import '../services/data_status_exception.dart';

import '../models/data_status.dart';
import '../models/stop_type.dart';
import '../views/stop_items/items_view_mode.dart';

import '../models/stop_detail_vm.dart';
import '../services/navigation_service.dart';
import 'package:rxdart/rxdart.dart';

class StopDetailStore {
  final StopService _stopSvc;
  final NavigationService _navSvc;

  BehaviorSubject<StopDetailVm> model;
  BehaviorSubject<DataStatus> modelStatus;

  StopDetailStore(this._stopSvc, this._navSvc)
      : model = BehaviorSubject<StopDetailVm>.seeded(StopDetailVm()),
        modelStatus = BehaviorSubject<DataStatus>.seeded(DataStatus.loading);

  void loadDetail(String uuid) async {
    modelStatus.value = DataStatus.loading;

    model.value = StopDetailVm();

    try {
      model.value = await _stopSvc.getStopDetail(uuid);
      modelStatus.value = DataStatus.loaded;
    } on DataRetrievalException catch (e) {
      modelStatus.value = e.dataStatus;
    } on Exception {
      modelStatus.value = DataStatus.error;
    }
  }

  void handleFabPress() {
    modelStatus.value = DataStatus.loading;

    try {
      switch (model.value.data.stopType) {
        case StopType.pickup:
          _navSvc.showItems(model.value.data.stopId, ItemsViewMode.pickup);
          break;

        case StopType.dropoff:
          _navSvc.showItems(model.value.data.stopId, ItemsViewMode.dropoff);
          break;
      }
    } finally {
      modelStatus.value = DataStatus.loaded;
    }
  }
}
