// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Offer _$OfferFromJson(Map<String, dynamic> json) => Offer(
      id: json[r'$id'] as String,
      amount: json['amount'] as int,
      parcelId: json['parcel_id'] as String,
      parcelTitle: json['parcel_title'] as String,
      userId: json['user_id'] as String,
      username: json['username'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      phone: json['phone'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$OfferToJson(Offer instance) => <String, dynamic>{
      r'$id': instance.id,
      'amount': instance.amount,
      'parcel_id': instance.parcelId,
      'user_id': instance.userId,
      'parcel_title': instance.parcelTitle,
      'username': instance.username,
      'created_at': instance.createdAt.toIso8601String(),
      'phone': instance.phone,
      'status': instance.status,
    };
