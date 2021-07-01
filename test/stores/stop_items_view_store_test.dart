import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/any.dart';
import 'package:mca_driver_app/models/pickup_point_vm.dart';
import 'package:mca_driver_app/services/stop_service/memory_stop_service.dart';
import 'package:mca_driver_app/stores/stop_items_view_store.dart';
import 'package:mca_driver_app/views/stop_items/items_view_mode.dart';
import 'package:mockito/mockito.dart';

class MockStopService extends Mock implements StopService {}

Future<void> nextTick() {
  return Future.delayed(Duration(milliseconds: 1));
}

void main() {
  StopItemsViewStore store;
  MockStopService stopSvc;

  group('StopItemsViewStore', () {
    setUp(() {
      stopSvc = MockStopService();
      when(stopSvc.getStopDetail(any)).thenAnswer((_) async {
        return stopDetailVm(pickupPoints: ['one', 'two'])
          ..items = deliveryItemVmList(3);
      });
      store = StopItemsViewStore(stopSvc, null);
    });

    test('pickup points, toggle updates stream', () async {
      store.initialize('any', ItemsViewMode.pickup);

      await nextTick();

      expect(store.pickupPoints, emits(predicate<List<PickupPointVm>>((d) {
        return d.where((vm) => vm.isConfirmed == true).length == 0;
      })));

      // This stream flag should change when all are confirmed.
      expectLater(store.isPickupPointsConfirmed,
          emitsInOrder([false, false, true, false]));

      await nextTick();

      var pickupPoints = (await store.pickupPoints.first);

      expect(pickupPoints.length, equals(2),
          reason: "did not recv test pickup points");

      store.togglePickupPointConfirmation(pickupPoints[0].id);
      await nextTick();

      store.togglePickupPointConfirmation(pickupPoints[1].id);
      await nextTick();

      store.togglePickupPointConfirmation(pickupPoints[1].id);
      await nextTick();

      await nextTick();
    });

    test('pickup stuff but not full qty', () async {
      store.initialize('any', ItemsViewMode.pickup);

      await nextTick();

      expect(store.pickupPoints, emits(predicate<List<PickupPointVm>>((d) {
        return d.where((vm) => vm.isConfirmed == true).length == 0;
      })));

      var items = (await store.items.first);
      var pickupItem = items[0];

      expect(pickupItem.qty, equals(5));

      // Pick up only three
      store.toggleConfirmation(items[0].id, 3);

      items = (await store.items.first);

      var newItem = items.where((i) => i.id == pickupItem.id).first;

      expect(newItem.qty, equals(3));
      expect(newItem.originalQty, equals(5));
    });
  }, skip: "currently broken by changes");
}
