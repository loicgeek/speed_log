// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parcel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Parcel _$ParcelFromJson(Map<String, dynamic> json) => Parcel(
      id: json[r'$id'] as String,
      description: json['description'] as String,
      title: json['title'] as String,
      status: json['status'] as String,
      cityId: json['city_id'] as String,
      cityName: json['city_name'] as String,
      fromId: json['from_id'] as String,
      fromName: json['from_name'] as String,
      fromDescription: json['from_description'] as String,
      toId: json['to_id'] as String,
      toName: json['to_name'] as String,
      toDescription: json['to_description'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String,
      receiverName: json['receiver_name'] as String,
      receiverPhone: json['receiver_phone'] as String,
      weight: json['weight'] as num,
      createdAt: DateTime.parse(json['created_at'] as String),
      deliveryManName: json['delivery_man_name'] as String?,
      deliveryManPhone: json['delivery_man_phone'] as String?,
    )
      ..deliveryManId = json['delivery_man_id'] as String?
      ..deliveredAt = json['delivered_at'] as String?;

Map<String, dynamic> _$ParcelToJson(Parcel instance) => <String, dynamic>{
      r'$id': instance.id,
      'description': instance.description,
      'title': instance.title,
      'status': instance.status,
      'city_id': instance.cityId,
      'city_name': instance.cityName,
      'from_id': instance.fromId,
      'from_name': instance.fromName,
      'from_description': instance.fromDescription,
      'to_id': instance.toId,
      'to_name': instance.toName,
      'to_description': instance.toDescription,
      'sender_id': instance.senderId,
      'sender_name': instance.senderName,
      'receiver_name': instance.receiverName,
      'receiver_phone': instance.receiverPhone,
      'weight': instance.weight,
      'delivery_man_name': instance.deliveryManName,
      'delivery_man_phone': instance.deliveryManPhone,
      'delivery_man_id': instance.deliveryManId,
      'created_at': instance.createdAt.toIso8601String(),
      'delivered_at': instance.deliveredAt,
    };
