import 'package:http/http.dart';

typedef ClientFactory = Client Function();

///
/// This was copied as a private function from the http lib. Is useful.
///
Future<T> withClient<T>(Future<T> Function(Client) fn,
    {ClientFactory cf}) async {
  var client = cf != null ? cf() : Client();

  try {
    return await fn(client);
  } finally {
    client.close();
  }
}

_StringDateRange getRangeForDay(DateTime now) {
  var start = DateTime(now.year, now.month, now.day, 0, 0, 0);
  var end = DateTime(now.year, now.month, now.day, 23, 59, 59);

  return _StringDateRange()
    ..start = start.toUtc().toIso8601String()
    ..end = end.toUtc().toIso8601String();
}

class _StringDateRange {
  String start;
  String end;
}
