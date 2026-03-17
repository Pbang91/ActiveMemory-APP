import 'package:json_annotation/json_annotation.dart'; // freezed_annotation 대신 json_annotation만 있어도 됩니다!

part 'get_my_gym_machine_response.g.dart';

@JsonSerializable()
class GetMyGymMachineResponse {
  final int customMachineId;
  final String name;
  final String? memo;
  final GetMyGymMachineBodyPart bodyPart;
  final GetMyGymMachineStandardExercise standardExercise;
  final List<GetMyGymMachineMuscle> muscles;

  GetMyGymMachineResponse({
    required this.customMachineId,
    required this.name,
    this.memo,
    required this.bodyPart,
    required this.standardExercise,
    required this.muscles,
  });

  factory GetMyGymMachineResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMyGymMachineResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GetMyGymMachineResponseToJson(this);
}

@JsonSerializable()
class GetMyGymMachineBodyPart {
  final String code;
  final String name;

  GetMyGymMachineBodyPart({
    required this.code,
    required this.name,
  });

  factory GetMyGymMachineBodyPart.fromJson(Map<String, dynamic> json) =>
      _$GetMyGymMachineBodyPartFromJson(json);
}

@JsonSerializable()
class GetMyGymMachineStandardExercise {
  final int standardExerciseId;
  final String name;

  GetMyGymMachineStandardExercise({
    required this.standardExerciseId,
    required this.name,
  });

  factory GetMyGymMachineStandardExercise.fromJson(Map<String, dynamic> json) =>
      _$GetMyGymMachineStandardExerciseFromJson(json);
}

@JsonSerializable()
class GetMyGymMachineMuscle {
  final int muscleId;
  final String name;
  final String role;

  GetMyGymMachineMuscle({
    required this.muscleId,
    required this.name,
    required this.role,
  });

  factory GetMyGymMachineMuscle.fromJson(Map<String, dynamic> json) =>
      _$GetMyGymMachineMuscleFromJson(json);
}
