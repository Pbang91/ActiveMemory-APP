import 'package:active_memory/src/features/reference/domain/entity/exercise.dart';

abstract class ReferenceRepository {
  Future<List<StandardExercise>> getExercies();
}
