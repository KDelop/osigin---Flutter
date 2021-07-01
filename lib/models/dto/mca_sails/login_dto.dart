import 'package:json_annotation/json_annotation.dart';

import 'app_user_dto.dart';

part 'login_dto.g.dart';

/// Received after successful login.
@JsonSerializable()
class LoginDto {
  LoginDto();

  bool success;

  @JsonKey(nullable: true)
  String authToken;

  @JsonKey(nullable: true)
  String authTokenExpiration;

  @JsonKey(nullable: true)
  AppUserDto user;

  factory LoginDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDtoToJson(this);
}
