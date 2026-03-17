import 'package:active_memory/src/features/inventory/data/inventory_repository.dart';
import 'package:active_memory/src/features/inventory/domain/entity/custom_machine.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_gym_machine_view_model.g.dart';

@riverpod
class MyGymMachineViewModel extends _$MyGymMachineViewModel {
  @override
  FutureOr<List<CustomMachine>> build(int gymId) async {
    return await ref.read(inventoryRepositoryProvider).getMyGymMachine(gymId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(inventoryRepositoryProvider).getMyGymMachine(gymId);
    });
  }
}
