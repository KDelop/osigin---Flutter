import 'package:mca_driver_app/models/dto/mca_sails/order_detail_dto.dart';

import '../services/order_service.dart';
import '../services/service_locator.dart';

import '../models/data_status.dart';
import 'package:rxdart/rxdart.dart';

import '../services/navigation_service.dart';

class OrderListViewStore {
  BehaviorSubject<DataStatus> modelStatus =
      BehaviorSubject<DataStatus>.seeded(DataStatus.loading);

  BehaviorSubject<List<OrderDetailDto>> model =
      BehaviorSubject<List<OrderDetailDto>>.seeded([]);

  OrderService _orderSvc;
  NavigationService _navSvc;

  OrderListViewStore() {
    _orderSvc = sl.get<OrderService>();
    _navSvc = sl.get<NavigationService>();
  }

  void getLatestItems() async {
    modelStatus.value = DataStatus.loading;
    try {
      model.value = await _orderSvc.getOrdersPendingConfirmation();
    } finally {
      modelStatus.value = DataStatus.loaded;
    }
  }

  void handleItemTap(String uuid) {
    _navSvc.showOrderDetail(uuid);
  }
}
