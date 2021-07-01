import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/models/dto/mca_sails/order_status.dart';
import 'package:mca_driver_app/repo/order_repository.dart';

import '../int_test_util.dart';
import '../test_env.dart';

void main() {
  group('OrderRepository', () {
    AuthClientParts parts;
    OrderRepository repo;

    setUpAll(() async {
      parts =
          await establishAuthenticatedClient(intTestDriver, intTestPassword);
      repo = OrderRepository(parts.mcaHttpClient);
    });

    test('my orders pending response', () async {
      var orders = await repo.getMyOrdersPendingResponse();

      for (var order in orders) {
        expect(order.status, equals(OrderStatus.assigned));
        expect(order.stops.length, greaterThanOrEqualTo(2));
      }
    });

    test('order by id', () async {
      var orders = await repo.getMyOrdersPendingResponse();

      expect(orders.length, greaterThan(0),
          reason: "Recv no pending orders, cant verify");

      var focusOrder = orders[0];
      var orderId = focusOrder.id;
      var order = await repo.getOrderById(orderId);

      expect(order, isNot(null), reason: "recv null when querying by id");
      expect(order.toJson(), equals(orders[0].toJson()));
    });

    test('order accept', () async {
      var orders = await repo.getMyOrdersPendingResponse();

      expect(orders.length, greaterThan(0),
          reason: "Recv no pending orders, cant verify");

      var focusOrder = orders[0];
      var orderId = focusOrder.id;
      var order = await repo.getOrderById(orderId);

      expect(order.status, equals(OrderStatus.assigned),
          reason: "expected order to be in assigned state before accepting");

      await repo.acceptOrder(orderId);

      var newOrder = await repo.getOrderById(orderId);

      expect(newOrder.status, equals(OrderStatus.accepted));
    });

    test('order rejection', () async {
      var orders = await repo.getMyOrdersPendingResponse();

      expect(orders.length, greaterThan(0),
          reason: "Recv no pending orders, cant verify");

      var focusOrder = orders[0];
      var orderId = focusOrder.id;
      var order = await repo.getOrderById(orderId);

      expect(order.status, equals(OrderStatus.assigned),
          reason: "expected order to be in assigned state before accepting");

      await repo.rejectOrder(orderId);

      var newOrder = await repo.getOrderById(orderId);

      expect(newOrder.status, equals(OrderStatus.rejected));
    });
  });
}
