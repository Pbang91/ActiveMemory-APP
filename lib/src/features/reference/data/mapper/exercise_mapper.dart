import 'package:active_memory/src/features/reference/data/dto/get_exercise_response.dart';
import 'package:active_memory/src/features/reference/domain/exercise/entity/muscle.dart';
import 'package:active_memory/src/features/reference/domain/exercise/entity/standard_exercise.dart';
import 'package:active_memory/src/features/reference/domain/exercise/entity/standard_exercise_muscle.dart';

extension GetExerciseResponseMapper on GetExerciseResponse {
  StandardExercise toEntity() {
    return StandardExercise(
      id: id,
      name: name,
      description: description ?? '',
      bodyPartName: bodyPart.name,
      bodyPartCode: bodyPart.code,
      equipmentName: exerciseType.koName,
      targetMuscles: muscles
              ?.map((m) => StandardExerciseMuscle(
                    id: m.id,
                    name: m.name,
                    role: m.role,
                  ))
              .toList() ??
          [],
    );
  }
}

extension GetMuscleResponseMapper on GetMuscleResponse {
  Muscle toEntity() {
    return Muscle(id: id, name: name);
  }
}
