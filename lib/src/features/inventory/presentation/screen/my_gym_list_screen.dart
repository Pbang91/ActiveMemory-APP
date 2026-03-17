import 'package:active_memory/src/features/inventory/domain/entity/my_gym.dart';
import 'package:active_memory/src/features/inventory/presentation/screen/my_gym_detail_screen.dart';
import 'package:active_memory/src/features/inventory/presentation/view_models/my_gym_view_model.dart';
import 'package:active_memory/src/features/reference/presentation/screen/gym_search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../common/theme/app_colors.dart';

class MyGymListScreen extends ConsumerWidget {
  const MyGymListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myGymState = ref.watch(myGymViewModelProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text("내 체육관"),
        ),
        // 체육관 추가 버튼 (Floating Action Button)
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final isAdded = await Navigator.push<bool>(context,
                MaterialPageRoute(builder: (_) => const GymSearchScreen()));

            if (isAdded == true) {
              ref.read(myGymViewModelProvider.notifier).refresh();
            }
          },
          icon: const Icon(Icons.add),
          label: const Text("체육관 등록"),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
        ),
        body: myGymState.when(
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
            error: (error, stack) => Center(
                  child: Text(
                    '데이터를 불러오지 못했습니다.\n$error',
                    textAlign: TextAlign.center,
                  ),
                ),
            data: (myGyms) {
              if (myGyms.isEmpty) {
                return const Center(
                  child: Text(
                    "등록된 체육관이 없습니다.\n아래 + 버튼을 눌러 추가해보세요!",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: myGyms.length,
                separatorBuilder: (_, __) => const SizedBox(
                  height: 12,
                ),
                itemBuilder: (context, index) {
                  final gym = myGyms[index];
                  return _buildGymCard(context, gym);
                },
              );
            }));
  }

  Widget _buildGymCard(BuildContext context, MyGym myGym) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => MyGymDetailScreen(
                          gymId: myGym.myGymId,
                          gymName: myGym.name,
                        )));
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // 아이콘
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.fitness_center,
                      color: AppColors.primary),
                ),
                const SizedBox(width: 16),

                // 텍스트 정보
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        myGym.name, // "에이블짐 역삼점"
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        myGym.address,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    ],
                  ),
                ),

                // 설정/삭제 메뉴
                IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.grey),
                  onPressed: () {
                    // TODO: 수정/삭제 바텀시트
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
