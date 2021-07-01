import 'package:json_annotation/json_annotation.dart';
import 'notification_dto.dart';

part 'order_assigned_notification_dto.g.dart';

@JsonSerializable()
class OrderAssignedNotificationDto extends NotificationDto {
  OrderAssignedNotificationDto(String message, this.orderId)
      : super("OrderAssigned", message);

  final String orderId;

  String toString() {
    return '<$runtimeType: $orderId, $message>';
  }

  bool operator ==(dynamic other) =>
      other is OrderAssignedNotificationDto && (message == other.message);

  int get hashCode => message.hashCode;

  factory OrderAssignedNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$OrderAssignedNotificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderAssignedNotificationDtoToJson(this);
}
