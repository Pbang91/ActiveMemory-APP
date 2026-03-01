import 'package:active_memory/src/features/inventory/data/inventory_repository.dart';
import 'package:active_memory/src/features/inventory/domain/entity/my_gym.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'my_gym_view_model.g.dart';

@riverpod
class MyGymViewModel extends _$MyGymViewModel {
  @override
  FutureOr<List<MyGym>> build() async {
    // 화면이 처음 그려질 때 자동으로 목록을 불러옴
    return await ref.read(inventoryRepositoryProvider).getMyGyms();
  }

  // 등록 후 수동으로 새로고침할 때 호출할 메서드
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref.read(inventoryRepositoryProvider).getMyGyms();
    });
  }
}
