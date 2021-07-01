import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/models/dto/mca_sails/item_dto.dart';
import 'package:mca_driver_app/repo/stop_repository.dart';

import '../int_test_util.dart';

void main() {
  group('StopsRepository', () {
    test('smoke test', () async {
      var client = await establishAuthenticatedIntTestClient();

      var repo = StopRepository(client);
      var stops = await repo.listMyStops();

      expect(stops.length, greaterThan(0),
          reason: "Did not receive any stops. Have any orders been accepted?");

      expect(stops.length, equals(8));

      var id = stops[0].stopId;

      await repo.getById(id);

      await repo.completePickup(id, items: [
        ItemDto()
          ..name = "pumps"
          ..qty = 4,
        ItemDto()
          ..name = "vials"
          ..qty = 10
      ], photos: [
        {"url": "https://example.com/1.jpg", "label": 'label'},
        {"url": "https://example.com/2.jpg", "label": 'label'}
      ]);

      await repo.completeDropoff(id, items: [
        ItemDto()
          ..name = "pumps"
          ..qty = 4,
        ItemDto()
          ..name = "vials"
          ..qty = 10
      ], photos: [
        {"url": "https://example.com/1.jpg", "label": 'label'},
        {"url": "https://example.com/2.jpg", "label": 'label'}
      ]);
    });
  });
}
