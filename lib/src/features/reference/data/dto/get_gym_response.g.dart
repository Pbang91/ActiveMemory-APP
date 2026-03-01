// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_gym_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetGymResponse _$GetGymResponseFromJson(Map<String, dynamic> json) =>
    GetGymResponse(
      providerId: json['providerId'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
    );

Map<String, dynamic> _$GetGymResponseToJson(GetGymResponse instance) =>
    <String, dynamic>{
      'providerId': instance.providerId,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
