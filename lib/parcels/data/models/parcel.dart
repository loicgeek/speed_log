import 'package:json_annotation/json_annotation.dart';

part 'parcel.g.dart';

@JsonSerializable()
class Parcel {
  @JsonKey(name: "\$id")
  late String id;
  late String description;
  late String title;
  late String status;

  @JsonKey(name: "city_id")
  late String cityId;
  @JsonKey(name: "city_name")
  late String cityName;

  @JsonKey(name: "from_id")
  late String fromId;

  @JsonKey(name: "from_name")
  late String fromName;

  @JsonKey(name: "from_description")
  late String fromDescription;

  @JsonKey(name: "to_id")
  late String toId;

  @JsonKey(name: "to_name")
  late String toName;

  @JsonKey(name: "to_description")
  late String toDescription;

  @JsonKey(name: "sender_id")
  late String senderId;

  @JsonKey(name: "sender_name")
  late String senderName;

  @JsonKey(name: "receiver_name")
  late String receiverName;
  @JsonKey(name: "receiver_phone")
  late String receiverPhone;
  late num weight;

  @JsonKey(name: "delivery_man_name")
  String? deliveryManName;
  @JsonKey(name: "delivery_man_phone")
  String? deliveryManPhone;
  @JsonKey(name: "delivery_man_id")
  String? deliveryManId;

  @JsonKey(name: "created_at")
  late DateTime createdAt;

  @JsonKey(name: "delivered_at")
  String? deliveredAt;
  Parcel({
    required this.id,
    required this.description,
    required this.title,
    required this.status,
    required this.cityId,
    required this.cityName,
    required this.fromId,
    required this.fromName,
    required this.fromDescription,
    required this.toId,
    required this.toName,
    required this.toDescription,
    required this.senderId,
    required this.senderName,
    required this.receiverName,
    required this.receiverPhone,
    required this.weight,
    required this.createdAt,
    this.deliveryManName,
    this.deliveryManPhone,
  });

  /// Connect the generated [_$ParcelFromJson] function to the `fromJson`
  /// factory.
  factory Parcel.fromJson(Map<String, dynamic> json) => _$ParcelFromJson(json);

  /// Connect the generated [_$ParcelToJson] function to the `toJson` method.
  Map<String, dynamic> toJson() => _$ParcelToJson(this);
}
