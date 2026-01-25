import 'package:active_memory/src/features/reference/data/reference_repository.dart';
import 'package:active_memory/src/features/reference/domain/entity/exercise.dart';
import 'package:active_memory/src/features/reference/domain/repository/reference_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. State: UI 상태 관리
class ReferenceState {
  final List<StandardExercise> allExercises; // 원본 데이터 (서버에서 받음)
  final List<StandardExercise> filteredExercises; // 필터링된 데이터 (화면 표시용)
  final String selectedBodyPart; // 선택된 대분류 코드 (예: 'CHEST', 'ALL')
  final String searchQuery; // 검색어
  final bool isLoading; // 로딩 상태

  ReferenceState({
    this.allExercises = const [],
    this.filteredExercises = const [],
    this.selectedBodyPart = 'ALL',
    this.searchQuery = '',
    this.isLoading = true,
  });

  ReferenceState copyWith({
    List<StandardExercise>? allExercises,
    List<StandardExercise>? filteredExercises,
    String? selectedBodyPart,
    String? searchQuery,
    bool? isLoading,
  }) {
    return ReferenceState(
      allExercises: allExercises ?? this.allExercises,
      filteredExercises: filteredExercises ?? this.filteredExercises,
      selectedBodyPart: selectedBodyPart ?? this.selectedBodyPart,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// 2. ViewModel: 비즈니스 로직
class ReferenceViewModel extends StateNotifier<ReferenceState> {
  final ReferenceRepository _repository;

  ReferenceViewModel(this._repository) : super(ReferenceState()) {
    loadExercises(); // 생성 시 데이터 로드
  }

  // 초기 데이터 로드 (API 호출)
  Future<void> loadExercises() async {
    try {
      state = state.copyWith(isLoading: true);

      // Repository를 통해 Entity 리스트를 받아옴
      final exercises =
          await _repository.getExercies(); // (오타 그대로 유지: getExercies)

      state = state.copyWith(
        allExercises: exercises,
        filteredExercises: exercises, // 처음엔 전체 표시
        isLoading: false,
      );
    } catch (e) {
      // 에러 처리 (실무에선 Toast나 Snackbar 처리 필요)
      print("운동 데이터 로드 실패: $e");
      state = state
          .copyWith(isLoading: false, allExercises: [], filteredExercises: []);
    }
  }

  // 필터링 적용 (메모리 연산)
  void _applyFilter() {
    final result = state.allExercises.where((ex) {
      // 1. 대분류 필터 (Entity의 bodyPartCode 사용)
      final matchPart = state.selectedBodyPart == 'ALL' ||
          ex.bodyPartCode == state.selectedBodyPart;

      // 2. 검색어 필터 (Entity의 name 사용)
      final matchQuery =
          state.searchQuery.isEmpty || ex.name.contains(state.searchQuery);

      return matchPart && matchQuery;
    }).toList();

    state = state.copyWith(filteredExercises: result);
  }

  // 대분류 탭 선택 시
  void selectBodyPart(String code) {
    state = state.copyWith(selectedBodyPart: code);
    _applyFilter();
  }

  // 검색어 입력 시
  void search(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilter();
  }
}

// 3. Provider: 뷰모델 주입
final referenceViewModelProvider =
    StateNotifierProvider<ReferenceViewModel, ReferenceState>((ref) {
  // Repository Provider를 watch하여 주입
  final repository = ref.watch(referenceRepositoryProvider);
  return ReferenceViewModel(repository);
});
