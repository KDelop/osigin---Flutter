// Base class for Notifications received from the push service

import 'package:json_annotation/json_annotation.dart';
import "package:meta/meta.dart";

part 'notification_dto.g.dart';

@JsonSerializable()
@immutable
class NotificationDto {
  final String type;
  final String message;

  NotificationDto(this.type, this.message);

  bool operator ==(dynamic other) =>
      other is NotificationDto && (message == other.message);

  int get hashCode => message.hashCode;

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationDtoToJson(this);
}
