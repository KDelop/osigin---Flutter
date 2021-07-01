import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/any.dart' as any;
import 'package:mca_driver_app/models/delivery_item_vm.dart';
import 'package:mca_driver_app/models/dto/mca_sails/item_dto.dart';
import 'package:mca_driver_app/services/stop_mapper.dart';

void main() {
  group('StopMapper', () {
    StopMapper mapper;
    setUp(() {
      mapper = StopMapper();
    });
    test('mapStopDetailDtoToStopListTile smoke test', () {
      mapper.mapStopDetailDtoToStopDetailVm(any.stopDetailDto());
    });

    group('mapStopDetailDtoToStopDetailVm', () {
      test('items', () {
        var dto = any.stopDetailDto();

        dto.items = [
          ItemDto()
            ..name = 'shovels'
            ..qty = 8,
          ItemDto()
            ..name = 'squirrels'
            ..qty = 2,
        ];

        var result = mapper.mapStopDetailDtoToStopDetailVm(dto);

        expect(
            result.items,
            contains(predicate<DeliveryItemVm>(
                (item) => item.description == 'shovels' && item.qty == 8)));

        expect(
            result.items,
            contains(predicate<DeliveryItemVm>(
                (item) => item.description == 'squirrels' && item.qty == 2)));
      }, skip: 'Items are changing requirements atm');

      test('stopTime', () {
        var testTime = DateTime.now().add(Duration(hours: 3)).toUtc();

        var dto = any.stopDetailDto()
          // Have to set a time within our current time offset, because it
          // seems like DateTime is Daylight Savings Time aware.. :(
          ..scheduledTime = DateTime.fromMicrosecondsSinceEpoch(
              testTime.microsecondsSinceEpoch,
              isUtc: true);

        var result = mapper.mapStopDetailDtoToStopDetailVm(dto);

        expect(result.data.scheduledTime.timeZoneOffset,
            equals(DateTime.now().timeZoneOffset),
            reason: "Time zone offset should match our local timezone offset "
                "${DateTime.now().timeZoneOffset}");

        expect(result.data.scheduledTime.toUtc(), equals(testTime));
      });

      test('pickupPoints', () {
        var dto = any.stopDetailDto();

        dto.pickupPoints = ['harry', 'mcfarry'];

        var result = mapper.mapStopDetailDtoToStopDetailVm(dto);

        var resultDescriptions =
            result.pickupPoints.map((vm) => vm.description);

        expect(resultDescriptions,
            contains(predicate((s) => s.contains('harry'))));

        expect(resultDescriptions,
            contains(predicate((s) => s.contains('mcfarry'))));
      });
    });
  });
}
