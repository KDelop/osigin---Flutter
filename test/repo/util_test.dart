import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/repo/util.dart';

void main() {
  test('repo utils', () {
    var now = DateTime(2005, 5, 10, 4, 5, 6);

    var expectedStart =
        DateTime(2005, 5, 10, 0, 0, 0).toUtc().toIso8601String();
    var expectedEnd =
        DateTime(2005, 5, 10, 23, 59, 59).toUtc().toIso8601String();

    expect(getRangeForDay(now).start, equals(expectedStart));
    expect(getRangeForDay(now).end, equals(expectedEnd));
  });
}
