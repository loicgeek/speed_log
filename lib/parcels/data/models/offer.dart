import 'package:json_annotation/json_annotation.dart';

part 'offer.g.dart';

@JsonSerializable()
class Offer {
  @JsonKey(name: "\$id")
  String id;
  int amount;

  @JsonKey(name: "parcel_id")
  String parcelId;

  @JsonKey(name: "user_id")
  String userId;
  @JsonKey(name: "parcel_title")
  String parcelTitle;
  String username;
  @JsonKey(name: "created_at")
  DateTime createdAt;
  String phone;
  String status;
  Offer({
    required this.id,
    required this.amount,
    required this.parcelId,
    required this.parcelTitle,
    required this.userId,
    required this.username,
    required this.createdAt,
    required this.phone,
    required this.status,
  });

  /// Connect the generated [_$OfferFromJson] function to the `fromJson`
  /// factory.
  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

  /// Connect the generated [_$OfferToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$OfferToJson(this);
}
