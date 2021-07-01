import 'package:mca_driver_app/models/dto/mca_sails/order_detail_dto.dart';

import '../services/navigation_service.dart';
import '../services/service_locator.dart';

import '../services/order_service.dart';

import '../services/data_status_exception.dart';

import '../models/data_status.dart';

import 'package:rxdart/rxdart.dart';

class OrderDetailStore {
  final OrderService _orderSvc;

  BehaviorSubject<OrderDetailDto> model;
  BehaviorSubject<DataStatus> modelStatus;

  OrderDetailStore(this._orderSvc)
      : model = BehaviorSubject<OrderDetailDto>.seeded(OrderDetailDto()),
        modelStatus = BehaviorSubject<DataStatus>.seeded(DataStatus.loading);

  void acceptOrder() async {
    modelStatus.value = DataStatus.loading;

    try {
      await _orderSvc.acceptOrder(model.value.id);

      modelStatus.value = DataStatus.loaded;
    } on DataRetrievalException catch (e) {
      modelStatus.value = e.dataStatus;
    } on Exception {
      modelStatus.value = DataStatus.error;
    }

    loadDetail(model.value.id);
  }

  void rejectOrder() async {
    modelStatus.value = DataStatus.loading;

    try {
      await _orderSvc.rejectOrder(model.value.id);

      modelStatus.value = DataStatus.loaded;
    } on DataRetrievalException catch (e) {
      modelStatus.value = e.dataStatus;
    } on Exception {
      modelStatus.value = DataStatus.error;
    }

    loadDetail(model.value.id);
  }

  void loadDetail(String uuid) async {
    modelStatus.value = DataStatus.loading;

    model.value = OrderDetailDto();

    try {
      model.value = await _orderSvc.getOrderDetail(uuid);
      modelStatus.value = DataStatus.loaded;
    } on DataRetrievalException catch (e) {
      modelStatus.value = e.dataStatus;
    } on Exception {
      modelStatus.value = DataStatus.error;
    }
  }

  void handleStopTap(String uuid) {
    sl.get<NavigationService>().showStopDetail(uuid);
  }
}
