// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'base_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SuccessResponse<T> _$SuccessResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) =>
    SuccessResponse<T>(
      data: fromJsonT(json['data']),
    );

Map<String, dynamic> _$SuccessResponseToJson<T>(
  SuccessResponse<T> instance,
  Object? Function(T value) toJsonT,
) =>
    <String, dynamic>{
      'data': toJsonT(instance.data),
    };

ExceptionResponse _$ExceptionResponseFromJson(Map<String, dynamic> json) =>
    ExceptionResponse(
      code: json['code'] as String,
      description: json['description'] as String,
      details: json['details'] as String,
    );

Map<String, dynamic> _$ExceptionResponseToJson(ExceptionResponse instance) =>
    <String, dynamic>{
      'code': instance.code,
      'description': instance.description,
      'details': instance.details,
    };
