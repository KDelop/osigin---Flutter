import 'dart:io';

import 'push_test.dart' as push_test;

Future main() async {
  var server = await HttpServer.bind(
    InternetAddress.anyIPv4,
    4040,
  );
  print('Listening on localhost:${server.port}');

  await for (HttpRequest request in server) {
    var pushToken = request.uri.queryParameters['push_token'];
    var notification = request.uri.queryParameters['notification'];

    try {
      push_test.main(["--type", notification, "--push-token", pushToken]);

      request.response.write("OK");
    } on Exception catch (e) {
      request.response.write(e);
    } finally {
      request.response.close();
    }
  }
}
