// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_me_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMeResponse _$GetMeResponseFromJson(Map<String, dynamic> json) =>
    GetMeResponse(
      id: (json['id'] as num).toInt(),
      email: json['email'] as String?,
      nickname: json['nickname'] as String,
      bio: json['bio'] as String?,
      authType: json['authType'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$GetMeResponseToJson(GetMeResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'nickname': instance.nickname,
      'bio': instance.bio,
      'authType': instance.authType,
      'createdAt': instance.createdAt,
    };
