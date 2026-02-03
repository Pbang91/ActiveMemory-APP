import 'package:active_memory/src/common/widget/common_message_view.dart';
import 'package:active_memory/src/features/reference/domain/exercise/entity/exercise.dart';
import 'package:active_memory/src/features/reference/presentation/screen/exercise_detail_screen.dart';
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

  // 탭 데이터 (필터링용 UI 메타데이터)
  // 실제로는 Meta API에서 받아올 수도 있지만, UI 탭 구성용으로 로컬 정의도 무방함
  final List<Map<String, String>> _bodyParts = [
    {'code': 'ALL', 'name': '전체'},
    {'code': 'CHEST', 'name': '가슴'},
    {'code': 'BACK', 'name': '등'},
    {'code': 'LEG', 'name': '하체'},
    {'code': 'SHOULDER', 'name': '어깨'},
    {'code': 'ARM', 'name': '팔'},
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
    final notifier = ref.read(referenceViewModelProvider.notifier);

    return Scaffold(
        // [Theme] 배경색 자동 적용 (AppColors.background)
        appBar: AppBar(title: const Text("Reference")),
        body: RefreshIndicator(
          onRefresh: () async {
            await notifier.loadExercises();
          },
          child: state.isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    // 1. 검색바
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => ref
                            .read(referenceViewModelProvider.notifier)
                            .search(value),
                        decoration: InputDecoration(
                          hintText: "운동 이름 검색",
                          hintStyle:
                              const TextStyle(color: AppColors.textSecondary),
                          prefixIcon: const Icon(Icons.search,
                              color: AppColors.primary),
                          filled: true,
                          fillColor: AppColors.surface, // 흰색 배경
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),

                          // 둥근 스타일 (Pill Shape)
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
                            borderSide: const BorderSide(
                                color: AppColors.primary, width: 1.5),
                          ),
                        ),
                      ),
                    ),

                    // 2. 대분류 탭 (가로 스크롤)
                    SizedBox(
                      height: 36,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: _bodyParts.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final part = _bodyParts[index];
                          final isSelected =
                              state.selectedBodyPart == part['code'];

                          return GestureDetector(
                            onTap: () {
                              ref
                                  .read(referenceViewModelProvider.notifier)
                                  .selectBodyPart(part['code']!);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: isSelected
                                      ? Colors.transparent
                                      : Colors.grey.shade200,
                                ),
                              ),
                              child: Text(
                                part['name']!,
                                style: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : AppColors.textSecondary,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
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
                      child: _buildListContent(state, notifier),
                    ),
                  ],
                ),
        ));
  }

  // 운동 카드 아이템
  Widget _buildExerciseCard(BuildContext context, StandardExercise exercise) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
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
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              useSafeArea: true,
              builder: (context) => ExerciseDetailScreen(exercise: exercise),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                // 아이콘 영역 (첫 글자)
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      exercise.name.isNotEmpty ? exercise.name[0] : '?',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
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
                        // [Entity 활용] 가공된 필드 사용
                        "${exercise.bodyPartName} | ${exercise.equipmentName}",
                        style: Theme.of(context).textTheme.bodyMedium,
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

  Widget _buildListContent(ReferenceState state, ReferenceViewModel notifier) {
    // Case A: 아예 원본 데이터 로드에 실패한 경우 (또는 DB가 텅 빔)
    if (state.allExercises.isEmpty) {
      return CommonMessageView(
        message: "데이터를 불러오지 못했어요.\n인터넷 연결을 확인해주세요.",
        icon: Icons.wifi_off,
        retryText: "다시 불러오기",
        onRetry: () {
          //실패 시 재시도 버튼 연결
          notifier.loadExercises();
        },
      );
    }

    // Case B: 데이터는 있는데 필터/검색 결과가 없는 경우
    if (state.filteredExercises.isEmpty) {
      return const CommonMessageView(
        message: "검색 결과가 없습니다.",
        icon: Icons.search_off,
      );
    }

    // Case C: 정상 출력
    return ListView.separated(
      // RefreshIndicator가 작동하려면 스크롤 뷰가 항상 스크롤 가능해야 함
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      itemCount: state.filteredExercises.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return _buildExerciseCard(context, state.filteredExercises[index]);
      },
    );
  }
}
