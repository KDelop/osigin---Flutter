import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/models/dto/mca_sails/stop_detail_dto.dart';
import 'package:mca_driver_app/any.dart' as any;

void main() {
  var today = DateTime.now();

  var todayDayNumber = today.day.toString().padLeft(2, '0');
  var todayMonthNumber = today.month.toString().padLeft(2, '0');
  var testDate = '2020-$todayMonthNumber-${todayDayNumber}T23:57:03Z';

  group('StopDetailDto', () {
    test('correct time zone', () {
      var json = any.stopDetailDto().toJson();
      json['scheduledTime'] = testDate;

      var mapped = StopDetailDto.fromJson(json);

      expect(mapped.scheduledTime.timeZoneOffset,
          equals(DateTime.now().timeZoneOffset));

      expect(mapped.scheduledTime.toUtc(), equals(DateTime.parse(testDate)));
    });
  });

  group('StopListItemDto', () {
    test('correct time zone', () {
      var json = any.stopDetailDto().toJson();
      json['scheduledTime'] = testDate;

      var mapped = StopDetailDto.fromJson(json);

      expect(mapped.scheduledTime.timeZoneOffset,
          equals(DateTime.now().timeZoneOffset));

      expect(mapped.scheduledTime.toUtc(), equals(DateTime.parse(testDate)));
    });
  });
}
