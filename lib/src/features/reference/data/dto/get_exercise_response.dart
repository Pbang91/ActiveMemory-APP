import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_exercise_response.g.dart';

@JsonSerializable()
class GetExerciseResponse {
  final int id;
  final String name;
  final String? description;
  final GetExerciseBodyPart bodyPart;
  final GetExerciseType exerciseType;
  final List<GetExerciseMuscle>? muscles;

  GetExerciseResponse({
    required this.id,
    required this.name,
    this.description,
    required this.bodyPart,
    required this.exerciseType,
    this.muscles,
  });

  factory GetExerciseResponse.fromJson(Map<String, dynamic> json) =>
      _$GetExerciseResponseFromJson(json);
}

@JsonSerializable()
class GetExerciseBodyPart {
  final String code;
  final String name;

  GetExerciseBodyPart({
    required this.code,
    required this.name,
  });

  factory GetExerciseBodyPart.fromJson(Map<String, dynamic> json) =>
      _$GetExerciseBodyPartFromJson(json);
}

@JsonSerializable()
class GetExerciseType {
  final String name;
  final String koName;

  GetExerciseType({
    required this.name,
    required this.koName,
  });

  factory GetExerciseType.fromJson(Map<String, dynamic> json) =>
      _$GetExerciseTypeFromJson(json);
}

@JsonSerializable()
class GetExerciseMuscle {
  final int id;
  final String name;
  final String role;

  GetExerciseMuscle({
    required this.id,
    required this.name,
    required this.role,
  });

  factory GetExerciseMuscle.fromJson(Map<String, dynamic> json) =>
      _$GetExerciseMuscleFromJson(json);
}
