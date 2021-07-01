
import 'package:json_annotation/json_annotation.dart';

part 'certification_dto.g.dart';

@JsonSerializable()
class CertificationDto {

  CertificationDto();

  int id;
  String name;
  String description;
  bool isDeleted;

  factory CertificationDto.fromJson(
    Map<String, dynamic> json) => _$CertificationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CertificationDtoToJson(this);
}
