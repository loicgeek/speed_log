import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  @JsonKey(name: "\$id")
  late String id;
  late String name;
  late String email;
  late String phone;

  @JsonKey(name: "is_driver")
  late bool isDriver;
  @JsonKey(name: "is_available")
  late bool isAvailable;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.isDriver = false,
    this.isAvailable = false,
  });

  /// Connect the generated [_$UserModelFromJson] function to the `fromJson`
  /// factory.
  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  /// Connect the generated [_$UserModelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
