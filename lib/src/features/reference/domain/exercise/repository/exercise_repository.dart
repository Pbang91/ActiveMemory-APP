import 'package:active_memory/src/features/reference/domain/exercise/entity/muscle.dart';
import 'package:active_memory/src/features/reference/domain/exercise/entity/standard_exercise.dart';

abstract class ExerciseRepository {
  Future<List<StandardExercise>> getExercies();

  Future<List<Muscle>> getMuscles();
}
