import 'package:mca_driver_app/models/dto/mca_sails/stop_list_item_dto.dart';
import 'package:mca_driver_app/services/stop_service/memory_stop_service.dart';

import '../models/data_status.dart';

import 'package:rxdart/rxdart.dart';

import '../services/navigation_service.dart';

class StopListViewStore {
  BehaviorSubject<DataStatus> modelStatus =
      BehaviorSubject<DataStatus>.seeded(DataStatus.loading);

  BehaviorSubject<List<StopListItemDto>> model =
      BehaviorSubject<List<StopListItemDto>>.seeded([]);

  final StopService _stopSvc;
  final NavigationService _navSvc;

  StopListViewStore(this._stopSvc, this._navSvc);

  void getLatestItems() async {
    modelStatus.value = DataStatus.loading;
    try {
      model.value = await _stopSvc.getTodaysStops();
    } finally {
      modelStatus.value = DataStatus.loaded;
    }
  }

  // bool getRequireRecipient(String stopId) {
  //   return model.value.singleWhere((e) => e.stopId == stopId).
  //   requireRecipient;
  // }

  void handleItemTap(String uuid) {
    _navSvc.showStopDetail(uuid);
  }
}
