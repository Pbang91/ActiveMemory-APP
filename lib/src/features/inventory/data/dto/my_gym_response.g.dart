// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_gym_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMyGymResponse _$GetMyGymResponseFromJson(Map<String, dynamic> json) =>
    GetMyGymResponse(
      myGymId: (json['myGymId'] as num).toInt(),
      name: json['name'] as String,
      address: json['address'] as String,
      nickname: json['nickname'] as String?,
    );

Map<String, dynamic> _$GetMyGymResponseToJson(GetMyGymResponse instance) =>
    <String, dynamic>{
      'myGymId': instance.myGymId,
      'name': instance.name,
      'address': instance.address,
      'nickname': instance.nickname,
    };
