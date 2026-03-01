import 'package:active_memory/src/features/inventory/data/inventory_repository.dart';
import 'package:active_memory/src/features/inventory/domain/command/regitser_my_gym_command.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inventory_command_view_model.g.dart';

@riverpod
class InventoryCommandViewModel extends _$InventoryCommandViewModel {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> registerGym({
    required String providerId,
    required String name,
    required String address,
    required String x,
    required String y,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final command = RegisterMyGymCommand(
          providerId: providerId, name: name, address: address, x: x, y: y);

      await ref.read(inventoryRepositoryProvider).registerGym(command);
    });
  }
}
