import 'dart:async';
import 'package:mca_driver_app/models/dto/mca_sails/order_detail_dto.dart';
import 'package:mca_driver_app/models/notification.dart';

import '../repo/order_repository.dart';
import 'service_locator.dart';

class OrderService {
  OrderRepository _orderRepository;

  final StreamController<String> orderResponseStreamCtrl =
      StreamController<String>();

  OrderService() {
    _orderRepository = sl.get<OrderRepository>();
  }

  Future<List<OrderDetailDto>> getOrdersPendingConfirmation() async {
    var orders = await _orderRepository.getMyOrdersPendingResponse();
    return orders;
  }

  Future<List<OrderAssignedNotification>>
      getPendingOrderAssignedNotifications() async {
    var orders = await _orderRepository.getMyOrdersPendingResponse();

    return orders
        .map((e) => OrderAssignedNotification()
          ..orderId = e.id
          ..orderNumber = e.orderNumber.toString()
          ..orderName = e.name
          ..scheduledDate = e.scheduledDate
          ..orderStatus = e.status)
        .toList();
  }

  Future<OrderDetailDto> getOrderDetail(String uuid) async {
    var dto = await _orderRepository.getOrderById(uuid);
    return dto;
  }

  Future<void> acceptOrder(String uuid) async {
    await _orderRepository.acceptOrder(uuid);
    orderResponseStreamCtrl.add(uuid);
  }

  Future<void> rejectOrder(String uuid) async {
    await _orderRepository.rejectOrder(uuid);
    orderResponseStreamCtrl.add(uuid);
  }

  /// Emits when an order has been accepted/rejected
  Stream getOrderResponseStream() {
    return orderResponseStreamCtrl.stream.asBroadcastStream();
  }
}
