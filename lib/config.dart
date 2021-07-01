import 'dart:collection';
import 'package:dotenv/dotenv.dart' as environment;
const _endpoints = [
  'https://prodserver.sqrlrx.io',
  'https://devserver.sqrlrx.io',
  'https://devtest1-sqrlrx.ngrok.io',
  'http://10.0.2.2:1337',
  'http://127.0.0.1:1337',
  'https://sqrlrx-dev.eb.lona.space'
];

/// Possible endpoints we can connect to.
/// Adds in the environment varaible endpoint as the first option.
List<String> endpoints = (() {
  var appApiEndpoint = environment.env['APP_API_ENDPOINT'] ?? '';

  var list = LinkedHashSet<String>.from([appApiEndpoint] + _endpoints);

  if (appApiEndpoint == null) {
    list.remove('');
  }

  return list.toList();
})();
