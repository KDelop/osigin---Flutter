import 'dart:convert';
import 'dart:io';

_assertConfigurationAvailable(Map<String, String> config) {
  var nullEntries = config.entries.where((e) => e.value == null);

  if (nullEntries.length != 0) {
    stderr.writeln("MISSING CONFIGURATION!");

    for (var e in nullEntries) {
      stderr.writeln("Please define ${e.key}");
    }

    stderr.writeln("Refusing to write environment config. Exiting.");
    exit(1);
  }
}

Future<void> main() async {
  final config = {
    'APP_API_ENDPOINT': Platform.environment["APP_API_ENDPOINT"],
    'APP_VERSION': Platform.environment['APP_VERSION'],
  };

  _assertConfigurationAvailable(config);

  final filename = 'lib/.env.dart';
  File(filename).writeAsString("""
/// GENERATED FILE, DO NOT EDIT
//
// ignore_for_file: lines_longer_than_80_chars
// ignore_for_file: file_names


/// App configuration map.
final Map<String, String> environment = ${json.encode(config)};
  """);

  print('Wrote environment file to $filename');

  for (var key in config.keys) {
    print('$key: ${config[key]}');
  }
}
