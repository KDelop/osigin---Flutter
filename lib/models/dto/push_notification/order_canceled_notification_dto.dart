import 'package:json_annotation/json_annotation.dart';
import 'notification_dto.dart';
import 'package:meta/meta.dart';

part 'order_canceled_notification_dto.g.dart';

@JsonSerializable()
@immutable
class OrderCanceledNotificationDto extends NotificationDto {
  OrderCanceledNotificationDto(String message, this.orderId)
      : super("OrderCanceled", message);

  @JsonKey(nullable: false)
  final String orderId;

  String toString() {
    return '<$runtimeType: $orderId, $message>';
  }

  bool operator ==(dynamic other) =>
      other is OrderCanceledNotificationDto && hashCode == other.hashCode;

  int get hashCode => orderId.hashCode + type.hashCode + message.hashCode;

  factory OrderCanceledNotificationDto.fromJson(Map<String, dynamic> json) =>
      _$OrderCanceledNotificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderCanceledNotificationDtoToJson(this);
}
