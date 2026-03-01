// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_my_gym_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterMyGymRequest _$RegisterMyGymRequestFromJson(
        Map<String, dynamic> json) =>
    RegisterMyGymRequest(
      providerId: json['providerId'] as String,
      name: json['name'] as String,
      roadAddress: json['roadAddress'] as String?,
      address: json['address'] as String,
      phone: json['phone'] as String?,
      x: json['x'] as String,
      y: json['y'] as String,
    );

Map<String, dynamic> _$RegisterMyGymRequestToJson(
        RegisterMyGymRequest instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'name': instance.name,
      'roadAddress': instance.roadAddress,
      'address': instance.address,
      'phone': instance.phone,
      'x': instance.x,
      'y': instance.y,
    };
