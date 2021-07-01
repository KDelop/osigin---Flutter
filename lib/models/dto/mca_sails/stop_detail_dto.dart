import 'package:json_annotation/json_annotation.dart';
import 'package:mca_driver_app/models/dto/mca_sails/stop_item_dto.dart';
import 'package:mca_driver_app/models/stop_stage.dart';
import 'package:mca_driver_app/models/stop_type.dart';
import '../date_time_local_tz_converter.dart';
import 'base_stop_dto.dart';

part 'stop_detail_dto.g.dart';

@JsonSerializable()
@DateTimeLocalTzConverter()
class StopDetailDto extends BaseStopDto {
  StopDetailDto();

  String orderId;
  String orderName;

  List<String> requiredCerts;
  List<String> requiredEquipment;

  String locationContactName;
  String locationContactPhone;

  bool isPartOfRoute;

  @JsonKey(defaultValue: '', nullable: true)
  String locationInstructions;

  @JsonKey(defaultValue: '', nullable: true)
  String clientInstructions;

  @JsonKey(defaultValue: '', nullable: true)
  String stopInstructions;

  @JsonKey(defaultValue: '', nullable: true)
  String orderInstructions;

  List<dynamic> items;

  /// Places the driver should check to pick up items.
  List<String> pickupPoints;

  List<StopItemDto> pickedupStopItems;

  factory StopDetailDto.fromJson(Map<String, dynamic> json) =>
      _$StopDetailDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StopDetailDtoToJson(this);
}
