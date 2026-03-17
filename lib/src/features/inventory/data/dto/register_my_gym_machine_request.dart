import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_my_gym_machine_request.g.dart';

@JsonSerializable()
class RegisterMyGymMachineRequest {
  final String name;
  final int standardExerciseId;
  final String bodyPartCode;
  final List<RegisterMyGymMachineMuscleMappingDataRequest>
      muscleMappingDataList;
  final String? memo;

  RegisterMyGymMachineRequest({
    required this.name,
    required this.standardExerciseId,
    required this.bodyPartCode,
    this.muscleMappingDataList = const [],
    this.memo,
  });

  factory RegisterMyGymMachineRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterMyGymMachineRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterMyGymMachineRequestToJson(this);
}

@JsonSerializable()
class RegisterMyGymMachineMuscleMappingDataRequest {
  final int muscleId;
  final String role; // "PRIMARY" or "SECONDARY"

  RegisterMyGymMachineMuscleMappingDataRequest({
    required this.muscleId,
    required this.role,
  });

  factory RegisterMyGymMachineMuscleMappingDataRequest.fromJson(
          Map<String, dynamic> json) =>
      _$RegisterMyGymMachineMuscleMappingDataRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$RegisterMyGymMachineMuscleMappingDataRequestToJson(this);
}
