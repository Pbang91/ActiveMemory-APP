import 'package:active_memory/src/common/network/dio_client.dart';
import 'package:active_memory/src/features/inventory/data/inventory_api.dart';
import 'package:active_memory/src/features/inventory/data/mapper/my_gym_mapper.dart';
import 'package:active_memory/src/features/inventory/domain/command/regitser_my_gym_command.dart';
import 'package:active_memory/src/features/inventory/domain/entity/my_gym.dart';
import 'package:active_memory/src/features/inventory/domain/repository/inventory_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inventory_repository.g.dart';

@riverpod
InventoryRepository inventoryRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final api = InventoryApi(dio);
  return InventoryRepositoryImpl(api);
}

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryApi _api;

  InventoryRepositoryImpl(this._api);

  @override
  Future<int> registerGym(RegisterMyGymCommand command) async {
    final request = command.toDto();
    final response = await _api.registerGym(request);

    return response.data.myGymId;
  }

  @override
  Future<List<MyGym>> getMyGyms() async {
    final response = await _api.getMyGyms();

    return response.data.map((dto) => dto.toEntity()).toList();
  }
}
