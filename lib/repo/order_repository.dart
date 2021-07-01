import 'package:mca_driver_app/models/dto/mca_sails/order_detail_dto.dart';

import '../util/mca_http_client.dart';

class OrderRepository {
  final McaHttpClient _mcaHttpClient;

  OrderRepository(this._mcaHttpClient);

  Future<List<OrderDetailDto>> getMyOrdersPendingResponse() async {
    List<dynamic> json = await _mcaHttpClient.getJson('/mobile/orders'
        '?status=assigned');

    var results = json.map((order) => OrderDetailDto.fromJson(order));

    return results.toList();
  }

  Future<OrderDetailDto> getOrderById(String id) async {
    var json = await _mcaHttpClient.getJson('/mobile/orders/$id');

    return OrderDetailDto.fromJson(json);
  }

  Future<void> acceptOrder(String id) async {
    var result = await _mcaHttpClient.getJson('/orders/acceptOrder?'
        'id=$id');

    var success = result['success'] ?? false;

    if (success) {
      return;
    } else {
      throw Exception("Failed to accept order");
    }
  }

  Future<void> rejectOrder(String id) async {
    var result = await _mcaHttpClient.getJson('/orders/rejectOrder?'
        'id=$id');

    var success = result['success'] ?? false;

    if (success) {
      return;
    } else {
      throw Exception("Failed to accept order");
    }
  }
}
