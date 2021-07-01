import 'package:json_annotation/json_annotation.dart';
part 'stop_item_dto.g.dart';

@JsonSerializable()
class StopItemDto {
  String id;
  String orderId;
  String stopId;
  String type;
  String name;
  int pickedupCnt;
  int dropoffCnt;
  String masterItemId;
  String upc;
  String meta;
  String createdAt;
  String updatedAt;

  StopItemDto({
    this.id,
    this.orderId,
    this.stopId,
    this.type,
    this.name,
    this.pickedupCnt,
    this.dropoffCnt,
    this.masterItemId,
    this.upc,
    this.meta,
    this.createdAt,
    this.updatedAt,
  });

  factory StopItemDto.fromJson(Map<String, dynamic> json) =>
      _$StopItemDtoFromJson(json);
  Map<String, dynamic> toJson() => _$StopItemDtoToJson(this);
}
