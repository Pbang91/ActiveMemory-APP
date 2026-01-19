import 'package:active_memory/src/common/widget/common_message_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/theme/app_colors.dart';
import '../view_models/reference_view_model.dart';

class ReferenceScreen extends ConsumerStatefulWidget {
  const ReferenceScreen({super.key});

  @override
  ConsumerState<ReferenceScreen> createState() => _ReferenceScreenState();
}

class _ReferenceScreenState extends ConsumerState<ReferenceScreen> {
  final TextEditingController _searchController = TextEditingController();

  // 탭 데이터 (임시)
  final List<Map<String, String>> _bodyParts = [
    {'code': 'ALL', 'name': '전체'},
    {'code': 'CHEST', 'name': '가슴'},
    {'code': 'BACK', 'name': '등'},
    {'code': 'LEGS', 'name': '하체'},
    {'code': 'SHOULDERS', 'name': '어깨'},
    {'code': 'ARMS', 'name': '팔'},
    {'code': 'ABS', 'name': '복근'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(referenceViewModelProvider);

    // 필터링 로직
    final filteredList = state.exercises.where((ex) {
      final matchPart = state.selectedBodyPart == 'ALL' ||
          (state.selectedBodyPart == 'CHEST' && ex.bodyPart == '가슴') ||
          (state.selectedBodyPart == 'BACK' && ex.bodyPart == '등') ||
          (state.selectedBodyPart == 'LEGS' && ex.bodyPart == '하체');
      final matchQuery = ex.name.contains(state.searchQuery);
      return matchPart && matchQuery;
    }).toList();

    return Scaffold(
      // 배경색은 Theme에 정의된 scaffoldBackgroundColor를 따름
      appBar: AppBar(
        title: const Text("Reference"),
        // AppBar 스타일은 AppTheme에서 자동 적용됨 (흰 배경, 검은 글씨)
      ),
      body: Column(
        children: [
          // 1. 검색바
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) =>
                  ref.read(referenceViewModelProvider.notifier).search(value),
              decoration: InputDecoration(
                hintText: "운동 이름 검색",
                hintStyle: const TextStyle(color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                filled: true,
                fillColor: AppColors.surface, // 흰색
                contentPadding: const EdgeInsets.symmetric(vertical: 12),

                // 검색바는 AppTheme의 기본 InputBorder(사각형) 말고 '둥근' 스타일을 씀
                // 색상은 AppColors 사용
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(color: AppColors.primary, width: 1.5),
                ),
              ),
            ),
          ),

          // 2. 대분류 탭
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _bodyParts.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final part = _bodyParts[index];
                final isSelected = state.selectedBodyPart == part['code'];

                return GestureDetector(
                  onTap: () {
                    ref
                        .read(referenceViewModelProvider.notifier)
                        .selectBodyPart(part['code']!);
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      // 선택 시 브랜드 컬러(Primary), 아니면 Surface
                      color: isSelected ? AppColors.primary : AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? Colors.transparent
                            : Colors.grey.shade200, // 테두리는 연하게
                      ),
                    ),
                    child: Text(
                      part['name']!,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // 3. 운동 리스트
          Expanded(
            child: filteredList.isEmpty
                // 공통 메시지 뷰 사용
                ? const CommonMessageView(
                    message: "검색 결과가 없습니다.",
                    icon: Icons.search_off,
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    itemCount: filteredList.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final exercise = filteredList[index];
                      return _buildExerciseCard(context, exercise);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(BuildContext context, ExerciseModel exercise) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface, // 흰색
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // 상세 바텀시트 호출
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 아이콘 영역
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.background, // 배경색(연회색)
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      exercise.name[0],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary, // 브랜드 컬러
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // 텍스트 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${exercise.bodyPart} | ${exercise.equipment}",
                        style: Theme.of(context).textTheme.bodyMedium, // 회색 텍스트
                      ),
                    ],
                  ),
                ),

                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
