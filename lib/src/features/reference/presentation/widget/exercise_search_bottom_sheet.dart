import 'package:active_memory/src/common/theme/app_colors.dart';
import 'package:active_memory/src/features/reference/presentation/view_models/reference_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExerciseSearchBottomSheet extends ConsumerStatefulWidget {
  const ExerciseSearchBottomSheet({super.key});

  @override
  ConsumerState<ExerciseSearchBottomSheet> createState() =>
      _ExerciseSearchBottomSheetState();
}

class _ExerciseSearchBottomSheetState
    extends ConsumerState<ExerciseSearchBottomSheet> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 바텀시트가 열릴 때 이전 검색어와 필터를 초기화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(referenceViewModelProvider.notifier).search('');
      ref.read(referenceViewModelProvider.notifier).selectBodyPart('ALL');
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Provider 상태 구독
    final state = ref.watch(referenceViewModelProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      padding: EdgeInsets.only(bottom: bottomInset),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // 1. 손잡이
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),

          // 2. 검색창
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "운동 종목 검색 (예: 렛풀다운)",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                // ViewModel의 검색 기능 호출
                ref.read(referenceViewModelProvider.notifier).search(value);
              },
            ),
          ),
          const SizedBox(height: 12),

          // 3. 대분류 필터 칩 (가로 스크롤)
          SizedBox(
            height: 40,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.bodyParts.length + 1,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final bool isAllTab = index == 0;

                final String code =
                    isAllTab ? 'ALL' : state.bodyParts[index - 1].code;
                final String name =
                    isAllTab ? '전체' : state.bodyParts[index - 1].name;

                final bool isSelected = state.selectedBodyPart == code;

                return ChoiceChip(
                  label: Text(name),
                  selected: isSelected,
                  selectedColor: AppColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.grey.shade700,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    // viewModel의 필터 기능 호출
                    if (selected) {
                      ref
                          .read(referenceViewModelProvider.notifier)
                          .selectBodyPart(code);
                    }
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 8),

          // 4. 검색 결과 리스트 (로딩 상태 포함)
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.filteredExercises.isEmpty
                    ? Center(
                        child: Text("검색 결과가 없습니다.",
                            style: TextStyle(color: Colors.grey.shade500)))
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        itemCount: state.filteredExercises.length,
                        separatorBuilder: (_, __) =>
                            Divider(color: Colors.grey.shade200),
                        itemBuilder: (context, index) {
                          // Entity 타입으로 가져오기
                          final exercise = state.filteredExercises[index];

                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(exercise.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            // Entity에 bodyPartName 필드가 있다면 사용, 없다면 매핑된 값 사용
                            subtitle: Text(exercise.bodyPartName,
                                style: TextStyle(
                                    color: Colors.grey.shade600, fontSize: 13)),
                            trailing: const Icon(Icons.chevron_right,
                                color: Colors.grey),
                            onTap: () {
                              // 선택된 StandardExercise 객체를 통째로 넘기면서 닫음
                              Navigator.pop(context, exercise);
                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
