import 'package:json_annotation/json_annotation.dart';

part 'delivery_location_point_dto.g.dart';

// todo: delete
@JsonSerializable()
class DeliveryLocationPointDto {
  DeliveryLocationPointDto();

  @JsonKey(name: 'id', nullable: false)
  String id; // sails string

  @JsonKey(name: 'LocationId', nullable: false)
  String locationId; // sails string

  @JsonKey(name: 'name', nullable: false)
  String name; // sails string

  @JsonKey(name: 'description', nullable: true)
  String description; // sails string

  @JsonKey(name: 'deletedOn', nullable: true)
  DateTime deletedOn; // sails datetime

  factory DeliveryLocationPointDto.fromJson(Map<String, dynamic> json) =>
      _$DeliveryLocationPointDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DeliveryLocationPointDtoToJson(this);
}
