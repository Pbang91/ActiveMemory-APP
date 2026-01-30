import 'package:active_memory/src/features/reference/domain/entity/exercise.dart';
import 'package:flutter/material.dart';

import '../../../../common/theme/app_colors.dart';

class ExerciseDetailScreen extends StatelessWidget {
  final StandardExercise exercise;

  const ExerciseDetailScreen({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    // 바텀시트의 모양과 내용을 정의
    return DraggableScrollableSheet(
      initialChildSize: 0.8, // 화면의 80% 높이로 시작
      minChildSize: 0.4, // 최소 40%
      maxChildSize: 0.9, // 최대 90% (위로 당기면 늘어남)
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // 1. 상단 핸들바 (드래그 가능하다는 힌트)
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),

              // 2. 스크롤 가능한 콘텐츠 영역
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- 헤더 섹션 ---
                      Center(
                        child: Column(
                          children: [
                            // 대형 아이콘
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Center(
                                child: Text(
                                  exercise.name.isNotEmpty
                                      ? exercise.name[0]
                                      : '?',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            // 운동 이름
                            Text(
                              exercise.name,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            // 간단 태그 (부위 | 장비)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "${exercise.bodyPartName} • ${exercise.equipmentName}",
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                      const Divider(height: 1),
                      const SizedBox(height: 32),

                      // --- 상세 내용 섹션 ---

                      // 1. 설명 (Description)
                      _buildSectionTitle(context, "운동 방법"),
                      const SizedBox(height: 12),
                      Text(
                        // 서버에서 description이 온다면 그걸 보여주고, 없으면 기본 메시지
                        exercise.description.isNotEmpty
                            ? exercise.description
                            : "올바른 자세로 운동을 수행하는 것이 중요합니다.\n부상 방지를 위해 적절한 무게를 선택하세요.",
                        style: const TextStyle(
                            fontSize: 16,
                            height: 1.6, // 줄 간격을 넓혀서 가독성 확보
                            color: AppColors.textSecondary),
                      ),

                      const SizedBox(height: 32),

                      // 2. 타겟 근육 (Muscles) - 칩 형태로 시각화
                      _buildSectionTitle(context, "자극 부위"),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8, // 가로 간격
                        runSpacing: 8, // 세로 간격
                        children: [
                          // Primary (주동근) - 진한 색
                          _buildChip(exercise.bodyPartName, isPrimary: true),

                          ...exercise.targetMuscles.map(
                            (muscleName) =>
                                _buildChip(muscleName, isPrimary: false),
                          )
                        ],
                      ),

                      const SizedBox(height: 40), // 하단 여백 확보
                    ],
                  ),
                ),
              ),

              // 3. 하단 버튼 (추후 '루틴에 추가' 기능 등을 위해)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: 루틴 추가 로직 or 닫기
                      Navigator.pop(context);
                    },
                    child: const Text("확인"),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 섹션 제목 위젯
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
    );
  }

  // 근육 칩 위젯
  Widget _buildChip(String label, {required bool isPrimary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isPrimary ? AppColors.secondary : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: isPrimary ? null : Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isPrimary ? Colors.white : AppColors.textSecondary,
          fontWeight: isPrimary ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
