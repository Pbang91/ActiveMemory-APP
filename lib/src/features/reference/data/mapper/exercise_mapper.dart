import 'package:active_memory/src/features/reference/data/dto/get_exercise_response.dart';
import 'package:active_memory/src/features/reference/domain/entity/exercise.dart';

extension GetExerciseResponseMapper on GetExerciseResponse {
  StandardExercise toEntity() {
    return StandardExercise(
      id: id,
      name: name,
      description: description,
      bodyPartName: bodyPart.name,
      bodyPartCode: bodyPart.code,
      equipmentName: exerciseType.koName,
    );
  }
}
