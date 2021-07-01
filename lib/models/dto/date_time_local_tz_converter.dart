import 'package:json_annotation/json_annotation.dart';

class DateTimeLocalTzConverter implements JsonConverter<DateTime, String> {
  const DateTimeLocalTzConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json).toLocal();

  @override
  String toJson(DateTime object) => object.toIso8601String();
}
