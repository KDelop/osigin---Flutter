import 'package:json_annotation/json_annotation.dart';

part 'recipient_model.g.dart';

@JsonSerializable()
class RecipientModel {
  RecipientModel({
    this.name = '',
    this.relation = '',
    this.notes = '',
  });

  String name;
  String relation;
  String notes;

  String toString() {
    return "id:$name $relation $notes";
  }

  factory RecipientModel.fromJson(Map<String, dynamic> json) =>
      _$RecipientModelFromJson(json);

  Map<String, dynamic> toJson() => _$RecipientModelToJson(this);
}
