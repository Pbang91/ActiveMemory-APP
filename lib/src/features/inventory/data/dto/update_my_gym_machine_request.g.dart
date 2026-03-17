// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_my_gym_machine_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateMyGymMachineRequest _$UpdateMyGymMachineRequestFromJson(
        Map<String, dynamic> json) =>
    UpdateMyGymMachineRequest(
      name: json['name'] as String,
      standardExerciseId: (json['standardExerciseId'] as num).toInt(),
      bodyPartCode: json['bodyPartCode'] as String,
      muscleMappingDataList: (json['muscleMappingDataList'] as List<dynamic>?)
              ?.map((e) => UpdateMyGymMachineMuscleMappingDataRequest.fromJson(
                  e as Map<String, dynamic>))
              .toList() ??
          const [],
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$UpdateMyGymMachineRequestToJson(
        UpdateMyGymMachineRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'standardExerciseId': instance.standardExerciseId,
      'bodyPartCode': instance.bodyPartCode,
      'muscleMappingDataList': instance.muscleMappingDataList,
      'memo': instance.memo,
    };

UpdateMyGymMachineMuscleMappingDataRequest
    _$UpdateMyGymMachineMuscleMappingDataRequestFromJson(
            Map<String, dynamic> json) =>
        UpdateMyGymMachineMuscleMappingDataRequest(
          muscleId: (json['muscleId'] as num).toInt(),
          role: json['role'] as String,
        );

Map<String, dynamic> _$UpdateMyGymMachineMuscleMappingDataRequestToJson(
        UpdateMyGymMachineMuscleMappingDataRequest instance) =>
    <String, dynamic>{
      'muscleId': instance.muscleId,
      'role': instance.role,
    };
