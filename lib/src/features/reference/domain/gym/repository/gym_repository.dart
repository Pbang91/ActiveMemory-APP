import 'package:active_memory/src/features/reference/domain/gym/entity/gym.dart';

abstract class GymRepository {
  Future<List<Gym>> getGyms(String keyword);
}
