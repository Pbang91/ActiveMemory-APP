import 'package:active_memory/src/features/reference/data/reference_repository.dart';
import 'package:active_memory/src/features/reference/domain/gym/entity/gym.dart';
import 'package:active_memory/src/features/reference/domain/gym/repository/gym_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 상태: 검색 결과 리스트 & 로딩 상태
class GymSearchState {
  final List<Gym> gyms;
  final bool isLoading;

  GymSearchState({this.gyms = const [], this.isLoading = false});

  GymSearchState copyWith({
    final List<Gym>? gyms,
    final bool? isLoading,
  }) {
    return GymSearchState(
      gyms: gyms ?? this.gyms,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class GymSearchViewModel extends StateNotifier<GymSearchState> {
  final GymRepository _gymRepository; // (API 호출용)

  GymSearchViewModel(this._gymRepository) : super(GymSearchState());

  // 검색 API 호출 (GET)
  Future<void> search(String query) async {
    if (query.isEmpty) return;

    state = GymSearchState(gyms: state.gyms, isLoading: true);

    try {
      final results = await _gymRepository.getGyms(query);
      state = GymSearchState(gyms: results, isLoading: false);
    } catch (e) {
      state = GymSearchState(gyms: [], isLoading: false);
    }
  }

  // 등록 API 호출 (POST)
  Future<void> registerGym(Gym gym) async {
    // await _gymRepository.registerMyGym(gym);
    // 성공 후 로직 (화면 닫기 등은 UI에서 처리하거나 여기서 콜백 호출)
  }
}

final gymSearchViewModelProvider =
    StateNotifierProvider.autoDispose<GymSearchViewModel, GymSearchState>(
        (ref) {
  return GymSearchViewModel(ref.watch(gymRepositoryProvider));
});
