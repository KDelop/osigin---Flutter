import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/models/delivery_item_vm.dart';
import 'package:mca_driver_app/services/navigation_service.dart';
import 'package:mca_driver_app/services/stop_service/memory_stop_service.dart';
import 'package:mca_driver_app/stores/stop_items_view_store.dart';
import 'package:mockito/mockito.dart';

class MockStopService extends Mock implements StopService {}

class MockNavigationService extends Mock implements NavigationService {}

// TODO: Critical, this is a fragmented test... consolidate into
// stop_items_view_store_test.dart

void main() {
  group('Stop Items View Store', () {
    test('addItem emits to the items', () async {
      var store =
          StopItemsViewStore(MockStopService(), MockNavigationService());

      store.addItem('Radio', 3);
      store.addItem('Rake', 8);

      expectLater(
          store.items,
          emits(predicate<List<DeliveryItemVm>>(
              (list) => list[0].description == 'Radio')));

      expectLater(
          store.items,
          emits(predicate<List<DeliveryItemVm>>(
              (list) => list[1].description == 'Rake')));

      var currentList = await store.items.first;

      expect(currentList[0].description, equals('Radio'));
      expect(currentList[0].qty, equals(3));
      expect(currentList[0].isConfirmed, equals(false));

      expect(currentList[1].description, equals('Rake'));
      expect(currentList[1].qty, equals(8));
      expect(currentList[1].isConfirmed, equals(false));

      // Test a toggle.

      store.toggleConfirmation(currentList[0].id, 2);

      currentList = await store.items.first;

      expect(currentList[0].description, equals('Radio'));
      expect(currentList[0].qty, equals(2));
      expect(currentList[0].originalQty, equals(3));
      expect(currentList[0].isConfirmed, equals(true));

      expect(currentList[1].description, equals('Rake'));
      expect(currentList[1].qty, equals(8));
      expect(currentList[1].isConfirmed, equals(false));
    });
  });
}
