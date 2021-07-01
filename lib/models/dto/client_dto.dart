import 'package:json_annotation/json_annotation.dart';

part 'client_dto.g.dart';

@JsonSerializable()
class ClientDto {
  String id;
  String businessName;
  String contactName;
  String address1;
  String address2;
  String city;
  String state;
  String zip;
  String phone;
  String email;

  /// Nullable
  @JsonKey(nullable: true)
  String specialInstructions;

  String createdOn;
  String updatedOn;

  /// any valid json value (nullable)
  @JsonKey(nullable: true)
  dynamic meta;

  ClientDto();

  factory ClientDto.fromJson(Map<String, dynamic> json) =>
      _$ClientDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ClientDtoToJson(this);
}
