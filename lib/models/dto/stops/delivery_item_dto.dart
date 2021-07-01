import 'package:json_annotation/json_annotation.dart';
import '../../../services/logger.dart';

part 'delivery_item_dto.g.dart';


/// This is a delivery item as it relates to a Stop
/// TODO--- how to consolidate the same (named) structure shown on Delivery?
@JsonSerializable()
class DeliveryItemDto {
  DeliveryItemDto();

  /// Getting hacky... sometimes this is needed... ?
  @JsonKey(name:"DeliveryId", nullable: true, includeIfNull: false)
  String deliveryId;

  @JsonKey(nullable: true, includeIfNull: false)
  String id;

  @JsonKey(nullable: true, includeIfNull: false)
  String name;

  int qty;

  @JsonKey(nullable: true, includeIfNull: false, defaultValue: true)
  bool isPrespecified;

  factory DeliveryItemDto.fromJson(Map<String, dynamic> json) {
    json['name'] = _establishItemName(json);
    return _$DeliveryItemDtoFromJson(json);
  }

  Map<String, dynamic> toJson() {
    var json = _$DeliveryItemDtoToJson(this);
    json['itemName'] = json['name'];
    return json;
  }

  String toString() {
    return '<Item name="$name" qty="$qty" />';
  }
}

String _establishItemName(Map<String, dynamic> json) {

  var name = json['name'] ?? json['itemName'];

  if (name == null) {
    name = 'Missing Name';
    logger.e('Could not find name for item in $json');
  }

  return name;
}