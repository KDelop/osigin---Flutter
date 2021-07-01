import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/any.dart';
import 'package:mca_driver_app/services/navigation_service.dart';
import 'package:mca_driver_app/services/service_locator.dart';
import 'package:mca_driver_app/services/stop_service/memory_stop_service.dart';
import 'package:mca_driver_app/stores/stop_items_view_store.dart';
import 'package:mca_driver_app/views/common/scaffold_builder.dart';
import 'package:mca_driver_app/views/stop_items/complete_fab.dart';
import 'package:mca_driver_app/views/stop_items/delivery_item_tile.dart';
import 'package:mca_driver_app/views/stop_items/items_view_mode.dart';
import 'package:mca_driver_app/views/stop_items/stop_items_view.dart';
import 'package:mockito/mockito.dart';

class MockStopService extends Mock implements StopService {}

class MockNavigationService extends Mock implements NavigationService {
  bool canPop() {
    return true;
  }
}

void main() {
  var it = test;
  var describe = group;

  group('when there are items', () {
    NavigationService navSvc;
    StopService stopSvc;

    testWidgets('should display the items', (tester) async {
      navSvc = MockNavigationService();
      stopSvc = MockStopService();

      when(stopSvc.getStopDetail(any)).thenAnswer((_) async {
        return stopDetailVm()
          ..items = [
            deliveryItemVm()
              ..description = "some item"
              ..isAddedDuringLoadXfer = false,
            deliveryItemVm()
              ..description = "some item 2"
              ..isAddedDuringLoadXfer = false
          ];
      });

      var stopItemsViewStore = StopItemsViewStore(stopSvc, navSvc);
      stopItemsViewStore.initialize('anystuff2', ItemsViewMode.pickup);

      sl.registerSingleton<StopItemsViewStore>(stopItemsViewStore);
      sl.registerSingleton<NavigationService>(navSvc);
      sl.registerSingleton<ScaffoldBuilder>(ScaffoldBuilder());

      var view = StopItemsView(mode: ItemsViewMode.pickup);

      await tester.pumpWidget(MaterialApp(home: view));

      await tester.pumpAndSettle();

      expect(find.byType(DeliveryItemTile), findsWidgets);

      var checkbox = find.descendant(
          of: find.byWidgetPredicate((w) =>
              w is DeliveryItemTile && w.itemVm.description == "some item"),
          matching: find.byType(Checkbox));

      await tester.tap(checkbox);

      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);

      var textForm = find.descendant(
          of: find.byType(AlertDialog), matching: find.byType(TextFormField));

      await tester.enterText(textForm, '9');

      await tester.tap(find.text('CONFIRM'));

      await tester.pumpAndSettle();

      expect(
          find.descendant(
              of: find.byWidgetPredicate((w) =>
                  w is DeliveryItemTile && w.itemVm.description == "some item"),
              matching: find.text('Qty: 9')),
          findsOneWidget);

      await tester.press(find.byType(CompleteFab));
      // TODO
      // await tester.tap(find.text('OK'));
    }, skip: true);
  }, skip: "disabled, due to changes and specs not updated");

  describe('when there are no items', () {
    it('should display the message saying thre are no items', () {});

    describe('when there are pickup points', () {
      it('should display the pickup points', () {});
    });
  });

  describe('when there are pickup points', () {
    describe('and the stop is a dropoff', () {
      it('should not display the pickup points box', () {});
    });

    describe('and the stop is a pickup', () {
      it('should display the pickup points box', () {});
    });

    describe('and the driver has selected all of them', () {
      it('should not prevent the driver from continuing', () {});
    });

    describe('and the driver has not selected all of them', () {
      it('should prevent the driver from continuing', () {});
    });
  });

  describe('when there are no pickup points', () {
    it('should not display the pickup points window', () {});
  });
}
