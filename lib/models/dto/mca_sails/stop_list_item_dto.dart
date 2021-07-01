import 'package:json_annotation/json_annotation.dart';
import 'package:mca_driver_app/models/dto/mca_sails/base_stop_dto.dart';
import 'package:mca_driver_app/models/stop_stage.dart';
import 'package:mca_driver_app/models/stop_type.dart';

import '../date_time_local_tz_converter.dart';

part 'stop_list_item_dto.g.dart';

@JsonSerializable()
@DateTimeLocalTzConverter()
class StopListItemDto extends BaseStopDto {
  StopListItemDto();

  factory StopListItemDto.fromJson(Map<String, dynamic> json) =>
      _$StopListItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$StopListItemDtoToJson(this);
}
