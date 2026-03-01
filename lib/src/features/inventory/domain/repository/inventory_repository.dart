import 'package:active_memory/src/features/inventory/domain/command/regitser_my_gym_command.dart';
import 'package:active_memory/src/features/inventory/domain/entity/my_gym.dart';

abstract class InventoryRepository {
  Future<int> registerGym(RegisterMyGymCommand command);

  Future<List<MyGym>> getMyGyms();
}
