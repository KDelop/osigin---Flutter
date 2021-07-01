import 'package:json_annotation/json_annotation.dart';
part 'dropoff_item_dto.g.dart';

@JsonSerializable()
class DropoffItemDto {
  String masterItemId;
  String name;
  int quantity;

  DropoffItemDto({
    this.masterItemId,
    this.name,
    this.quantity,
  });

  factory DropoffItemDto.fromJson(Map<String, dynamic> json) =>
      _$DropoffItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$DropoffItemDtoToJson(this);
}
