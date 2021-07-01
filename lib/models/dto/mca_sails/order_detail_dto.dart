import 'package:json_annotation/json_annotation.dart';
import 'package:mca_driver_app/models/dto/date_time_local_tz_converter.dart';
import 'package:mca_driver_app/models/dto/mca_sails/order_status.dart';
import 'package:mca_driver_app/models/dto/mca_sails/stop_list_item_dto.dart';

part 'order_detail_dto.g.dart';

@JsonSerializable()
@DateTimeLocalTzConverter()
class OrderDetailDto {
  OrderDetailDto();

  String id = '';
  String orderNumber = '';
  String clientName = '';
  String name = '';
  OrderStatus status = OrderStatus.assigned;
  DateTime scheduledDate = DateTime.now();
  List<String> requiredEquipment = [];
  List<String> requiredCerts = [];
  List<StopListItemDto> stops = [];

  factory OrderDetailDto.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailDtoToJson(this);
}
