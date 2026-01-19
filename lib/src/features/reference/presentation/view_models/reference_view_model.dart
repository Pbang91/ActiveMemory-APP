// UI 뿌릴 구조
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseModel {
  final int id;
  final String name;
  final String bodyPart;
  final String equipment;

  ExerciseModel(
      {required this.id,
      required this.name,
      required this.bodyPart,
      required this.equipment});
}

// 필터링 상태 관리
class ReferenceState {
  final String selectedBodyPart;
  final String searchQuery;
  final List<ExerciseModel> exercises;

  ReferenceState(
      {this.selectedBodyPart = 'ALL',
      this.searchQuery = '',
      this.exercises = const []});

  ReferenceState copyWith({
    String? selectedBodyPart,
    String? searchQuery,
    List<ExerciseModel>? exercises,
  }) {
    return ReferenceState(
      selectedBodyPart: selectedBodyPart ?? this.selectedBodyPart,
      searchQuery: searchQuery ?? this.searchQuery,
      exercises: exercises ?? this.exercises,
    );
  }
}

class ReferenceViewModel extends StateNotifier<ReferenceState> {
  ReferenceViewModel() : super(ReferenceState()) {
    _loadDummyData();
  }

  void _loadDummyData() {
    // 백엔드 API 연동 전 테스트 데이터
    final dummy = [
      ExerciseModel(id: 1, name: "벤치 프레스", bodyPart: "가슴", equipment: "바벨"),
      ExerciseModel(
          id: 2, name: "인클라인 덤벨 프레스", bodyPart: "가슴", equipment: "덤벨"),
      ExerciseModel(id: 3, name: "데드리프트", bodyPart: "등", equipment: "바벨"),
      ExerciseModel(id: 4, name: "랫 풀 다운", bodyPart: "등", equipment: "머신"),
      ExerciseModel(id: 5, name: "스쿼트", bodyPart: "하체", equipment: "바벨"),
      ExerciseModel(id: 6, name: "레그 익스텐션", bodyPart: "하체", equipment: "머신"),
    ];
    state = state.copyWith(exercises: dummy);
  }

  void selectBodyPart(String code) {
    state = state.copyWith(selectedBodyPart: code);
  }

  void search(String query) {
    state = state.copyWith(searchQuery: query);
  }
}

final referenceViewModelProvider =
    StateNotifierProvider<ReferenceViewModel, ReferenceState>((ref) {
  return ReferenceViewModel();
});
