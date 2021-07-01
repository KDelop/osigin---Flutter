import 'package:flutter_test/flutter_test.dart';
import 'package:mca_driver_app/any.dart' as any;

void main() {
  test('clientName produces infinite selections from a finite list', () {
    for (var i = 0; i < 60; i++) {
      var client = any.clientName();
      assert(client.length != 0);
    }
  });
}
