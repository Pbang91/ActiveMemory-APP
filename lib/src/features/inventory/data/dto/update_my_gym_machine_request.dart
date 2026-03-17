import 'package:json_annotation/json_annotation.dart';

part 'update_my_gym_machine_request.g.dart';

@JsonSerializable()
class UpdateMyGymMachineRequest {
  final String name;
  final int standardExerciseId;
  final String bodyPartCode;
  final List<UpdateMyGymMachineMuscleMappingDataRequest> muscleMappingDataList;
  final String? memo;

  UpdateMyGymMachineRequest({
    required this.name,
    required this.standardExerciseId,
    required this.bodyPartCode,
    this.muscleMappingDataList = const [],
    this.memo,
  });

  factory UpdateMyGymMachineRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateMyGymMachineRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateMyGymMachineRequestToJson(this);
}

@JsonSerializable()
class UpdateMyGymMachineMuscleMappingDataRequest {
  final int muscleId;
  final String role;

  UpdateMyGymMachineMuscleMappingDataRequest({
    required this.muscleId,
    required this.role,
  });

  factory UpdateMyGymMachineMuscleMappingDataRequest.fromJson(
          Map<String, dynamic> json) =>
      _$UpdateMyGymMachineMuscleMappingDataRequestFromJson(json);

  Map<String, dynamic> toJson() =>
      _$UpdateMyGymMachineMuscleMappingDataRequestToJson(this);
}
