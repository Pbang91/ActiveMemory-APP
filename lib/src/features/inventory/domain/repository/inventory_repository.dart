import 'package:active_memory/src/features/inventory/domain/command/register_my_gym_machine_command.dart';
import 'package:active_memory/src/features/inventory/domain/command/regitser_my_gym_command.dart';
import 'package:active_memory/src/features/inventory/domain/command/update_my_gym_machine_command.dart';
import 'package:active_memory/src/features/inventory/domain/entity/custom_machine.dart';
import 'package:active_memory/src/features/inventory/domain/entity/my_gym.dart';

abstract class InventoryRepository {
  Future<int> registerGym(RegisterMyGymCommand command);

  Future<List<MyGym>> getMyGyms();

  Future<List<CustomMachine>> getMyGymMachine(int gymId);

  Future<void> registerMyGymMachine(
      int gymId, RegisterMyGymMachineCommand command);

  Future<void> updateMyGymMachine(
      int gymId, int machineId, UpdateMyGymMachineCommand command);
}
