import 'package:json_annotation/json_annotation.dart';
part 'pickup_item_dto.g.dart';

@JsonSerializable()
class PickupItemDto {
  String name;
  int quantity;
  String upc;

  PickupItemDto({
    this.name,
    this.quantity,
    this.upc,
  });

  factory PickupItemDto.fromJson(Map<String, dynamic> json) =>
      _$PickupItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$PickupItemDtoToJson(this);
}
