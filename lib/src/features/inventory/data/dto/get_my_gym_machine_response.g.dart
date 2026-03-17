// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_my_gym_machine_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetMyGymMachineResponse _$GetMyGymMachineResponseFromJson(
        Map<String, dynamic> json) =>
    GetMyGymMachineResponse(
      customMachineId: (json['customMachineId'] as num).toInt(),
      name: json['name'] as String,
      memo: json['memo'] as String?,
      bodyPart: GetMyGymMachineBodyPart.fromJson(
          json['bodyPart'] as Map<String, dynamic>),
      standardExercise: GetMyGymMachineStandardExercise.fromJson(
          json['standardExercise'] as Map<String, dynamic>),
      muscles: (json['muscles'] as List<dynamic>)
          .map((e) => GetMyGymMachineMuscle.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetMyGymMachineResponseToJson(
        GetMyGymMachineResponse instance) =>
    <String, dynamic>{
      'customMachineId': instance.customMachineId,
      'name': instance.name,
      'memo': instance.memo,
      'bodyPart': instance.bodyPart,
      'standardExercise': instance.standardExercise,
      'muscles': instance.muscles,
    };

GetMyGymMachineBodyPart _$GetMyGymMachineBodyPartFromJson(
        Map<String, dynamic> json) =>
    GetMyGymMachineBodyPart(
      code: json['code'] as String,
      name: json['name'] as String,
    );

Map<String, dynamic> _$GetMyGymMachineBodyPartToJson(
        GetMyGymMachineBodyPart instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
    };

GetMyGymMachineStandardExercise _$GetMyGymMachineStandardExerciseFromJson(
        Map<String, dynamic> json) =>
    GetMyGymMachineStandardExercise(
      standardExerciseId: (json['standardExerciseId'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$GetMyGymMachineStandardExerciseToJson(
        GetMyGymMachineStandardExercise instance) =>
    <String, dynamic>{
      'standardExerciseId': instance.standardExerciseId,
      'name': instance.name,
    };

GetMyGymMachineMuscle _$GetMyGymMachineMuscleFromJson(
        Map<String, dynamic> json) =>
    GetMyGymMachineMuscle(
      muscleId: (json['muscleId'] as num).toInt(),
      name: json['name'] as String,
      role: json['role'] as String,
    );

Map<String, dynamic> _$GetMyGymMachineMuscleToJson(
        GetMyGymMachineMuscle instance) =>
    <String, dynamic>{
      'muscleId': instance.muscleId,
      'name': instance.name,
      'role': instance.role,
    };
