// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json[r'$id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      isDriver: json['is_driver'] as bool? ?? false,
      isAvailable: json['is_available'] as bool? ?? false,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      r'$id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'is_driver': instance.isDriver,
      'is_available': instance.isAvailable,
    };
