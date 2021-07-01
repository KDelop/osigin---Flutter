import 'package:json_annotation/json_annotation.dart';

part 'app_user_dto.g.dart';

/// Only serializing a subset of possible fields being returned.
@JsonSerializable()
class AppUserDto {
  AppUserDto();

  String id;
  String username;
  bool isActive;

  @JsonKey(nullable: true, defaultValue: {})
  Map<String, dynamic> meta;

  @JsonKey(defaultValue: "", nullable: true)
  String firstName;

  @JsonKey(defaultValue: "", nullable: true)
  String lastName;

  @JsonKey(defaultValue: "", nullable: true)
  String phone;

  @JsonKey(defaultValue: "", nullable: true)
  String email;

  factory AppUserDto.fromJson(Map<String, dynamic> json) =>
      _$AppUserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserDtoToJson(this);
}
