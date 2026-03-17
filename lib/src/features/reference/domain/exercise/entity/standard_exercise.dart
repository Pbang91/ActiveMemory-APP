import 'package:active_memory/src/features/reference/domain/exercise/entity/standard_exercise_muscle.dart';

class StandardExercise {
  final int id;
  final String name;
  final String description;
  final String bodyPartName; // code 한글
  final String bodyPartCode;
  final String equipmentName; // type 한글
  final List<StandardExerciseMuscle> targetMuscles;

  StandardExercise({
    required this.id,
    required this.name,
    required this.description,
    required this.bodyPartName,
    required this.bodyPartCode,
    required this.equipmentName,
    required this.targetMuscles,
  });
}
