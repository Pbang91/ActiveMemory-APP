import 'package:active_memory/src/common/theme/app_colors.dart';
import 'package:active_memory/src/features/reference/domain/exercise/entity/muscle.dart';
import 'package:active_memory/src/features/reference/domain/exercise/entity/standard_exercise_muscle.dart';
import 'package:active_memory/src/features/reference/presentation/view_models/muscle_list_provider.dart';
// import provider...
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MuscleSearchBottomSheet extends ConsumerStatefulWidget {
  // 이미 선택된 근육들을 받아서, 체크박스에 미리 체크해두기 위함!
  final List<int> alreadySelectedIds;

  const MuscleSearchBottomSheet({super.key, required this.alreadySelectedIds});

  @override
  ConsumerState<MuscleSearchBottomSheet> createState() =>
      _MuscleSearchBottomSheetState();
}

class _MuscleSearchBottomSheetState
    extends ConsumerState<MuscleSearchBottomSheet> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  //사용자가 현재 체크한 근육들을 임시 저장하는 Set
  final Map<Muscle, String> _selectedMusclesWithRole = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 근육 리스트 Provider 구독
    final musclesAsync = ref.watch(muscleListProvider);
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
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),

          // 1. 검색바
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "근육 검색 (예: 전면 삼각근)",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          const SizedBox(height: 12),

          // 2. 리스트 & 체크박스
          Expanded(
            child: musclesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('데이터를 불러올 수 없습니다.\n$err')),
              data: (allMuscles) {
                // 검색어 필터링
                final filtered = allMuscles
                    .where((m) => m.name.contains(_searchQuery))
                    .toList();

                if (filtered.isEmpty) {
                  return const Center(child: Text("검색 결과가 없습니다."));
                }

                return ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) =>
                      Divider(color: Colors.grey.shade100, height: 1),
                  itemBuilder: (context, index) {
                    final muscle = filtered[index];
                    // 이미 부모 화면에서 선택된 근육이거나, 지금 바텀시트에서 방금 체크한 근육인지 확인
                    final isAlreadyAdded =
                        widget.alreadySelectedIds.contains(muscle.id);

                    if (isAlreadyAdded) {
                      return ListTile(
                        title: Text(muscle.name,
                            style: TextStyle(color: Colors.grey.shade400)),
                        trailing: Text("이미 추가됨",
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 13)),
                      );
                    }

                    final currentRole = _selectedMusclesWithRole[muscle];

                    return ListTile(
                      title: Text(muscle.name,
                          style: const TextStyle(fontWeight: FontWeight.w500)),
                      // 🌟 핵심 UX: 우측에 주동근/협력근을 고를 수 있는 칩 배치
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ChoiceChip(
                            label: const Text('주동근'),
                            selected: currentRole == 'PRIMARY',
                            selectedColor: AppColors.primary.withOpacity(0.1),
                            checkmarkColor: AppColors.primary,
                            labelStyle: TextStyle(
                              color: currentRole == 'PRIMARY'
                                  ? AppColors.primary
                                  : Colors.grey.shade600,
                              fontWeight: currentRole == 'PRIMARY'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            side: BorderSide(
                                color: currentRole == 'PRIMARY'
                                    ? AppColors.primary
                                    : Colors.grey.shade300),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedMusclesWithRole[muscle] = 'PRIMARY';
                                } else {
                                  _selectedMusclesWithRole
                                      .remove(muscle); // 다시 누르면 선택 해제
                                }
                              });
                            },
                          ),
                          const SizedBox(width: 8),
                          ChoiceChip(
                            label: const Text('협력근'),
                            selected: currentRole == 'SECONDARY',
                            selectedColor: Colors.grey.shade200,
                            checkmarkColor: Colors.grey.shade700,
                            labelStyle: TextStyle(
                              color: currentRole == 'SECONDARY'
                                  ? Colors.grey.shade800
                                  : Colors.grey.shade600,
                              fontWeight: currentRole == 'SECONDARY'
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            side: BorderSide(
                                color: currentRole == 'SECONDARY'
                                    ? Colors.grey.shade400
                                    : Colors.grey.shade300),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedMusclesWithRole[muscle] =
                                      'SECONDARY';
                                } else {
                                  _selectedMusclesWithRole.remove(muscle);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // 3. 하단 '추가하기' 버튼
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: _selectedMusclesWithRole.isEmpty
                    ? null // 아무것도 안 골랐으면 버튼 비활성화
                    : () {
                        // 완료 버튼 누르면 선택된 Set을 List로 변환해서 이전 화면으로 넘김!
                        final resultList =
                            _selectedMusclesWithRole.entries.map((entry) {
                          return StandardExerciseMuscle(
                            id: entry.key.id,
                            name: entry.key.name,
                            role: entry
                                .value, // 유저가 선택한 역할 (PRIMARY or SECONDARY)
                          );
                        }).toList();

                        Navigator.pop(context, resultList);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: Colors.grey.shade300,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  _selectedMusclesWithRole.isEmpty
                      ? "근육과 역할을 선택해주세요"
                      : "${_selectedMusclesWithRole.length}개 추가하기",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
