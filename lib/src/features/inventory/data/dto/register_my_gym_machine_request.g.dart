// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'register_my_gym_machine_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterMyGymMachineRequest _$RegisterMyGymMachineRequestFromJson(
        Map<String, dynamic> json) =>
    RegisterMyGymMachineRequest(
      name: json['name'] as String,
      standardExerciseId: (json['standardExerciseId'] as num).toInt(),
      bodyPartCode: json['bodyPartCode'] as String,
      muscleMappingDataList: (json['muscleMappingDataList'] as List<dynamic>?)
              ?.map((e) =>
                  RegisterMyGymMachineMuscleMappingDataRequest.fromJson(
                      e as Map<String, dynamic>))
              .toList() ??
          const [],
      memo: json['memo'] as String?,
    );

Map<String, dynamic> _$RegisterMyGymMachineRequestToJson(
        RegisterMyGymMachineRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'standardExerciseId': instance.standardExerciseId,
      'bodyPartCode': instance.bodyPartCode,
      'muscleMappingDataList': instance.muscleMappingDataList,
      'memo': instance.memo,
    };

RegisterMyGymMachineMuscleMappingDataRequest
    _$RegisterMyGymMachineMuscleMappingDataRequestFromJson(
            Map<String, dynamic> json) =>
        RegisterMyGymMachineMuscleMappingDataRequest(
          muscleId: (json['muscleId'] as num).toInt(),
          role: json['role'] as String,
        );

Map<String, dynamic> _$RegisterMyGymMachineMuscleMappingDataRequestToJson(
        RegisterMyGymMachineMuscleMappingDataRequest instance) =>
    <String, dynamic>{
      'muscleId': instance.muscleId,
      'role': instance.role,
    };
