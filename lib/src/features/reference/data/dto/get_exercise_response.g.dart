// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_exercise_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetExerciseResponse _$GetExerciseResponseFromJson(Map<String, dynamic> json) =>
    GetExerciseResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      bodyPart: GetExerciseBodyPart.fromJson(
          json['bodyPart'] as Map<String, dynamic>),
      exerciseType: GetExerciseType.fromJson(
          json['exerciseType'] as Map<String, dynamic>),
      muscles: (json['muscles'] as List<dynamic>?)
          ?.map((e) => GetExerciseMuscle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetExerciseResponseToJson(
        GetExerciseResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'bodyPart': instance.bodyPart,
      'exerciseType': instance.exerciseType,
      'muscles': instance.muscles,
    };

GetExerciseBodyPart _$GetExerciseBodyPartFromJson(Map<String, dynamic> json) =>
    GetExerciseBodyPart(
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$GetExerciseBodyPartToJson(
        GetExerciseBodyPart instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

GetExerciseType _$GetExerciseTypeFromJson(Map<String, dynamic> json) =>
    GetExerciseType(
      name: json['name'] as String,
      koName: json['koName'] as String,
    );

Map<String, dynamic> _$GetExerciseTypeToJson(GetExerciseType instance) =>
    <String, dynamic>{
      'name': instance.name,
      'koName': instance.koName,
    };

GetExerciseMuscle _$GetExerciseMuscleFromJson(Map<String, dynamic> json) =>
    GetExerciseMuscle(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$GetExerciseMuscleToJson(GetExerciseMuscle instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'role': instance.role,
    };
