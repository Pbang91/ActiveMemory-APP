import 'package:active_memory/src/features/reference/domain/exercise/entity/exercise.dart';

abstract class ExerciseRepository {
  Future<List<StandardExercise>> getExercies();
}
