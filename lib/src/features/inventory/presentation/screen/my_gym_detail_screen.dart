import 'package:active_memory/src/common/theme/app_colors.dart';
import 'package:active_memory/src/features/inventory/domain/entity/custom_machine.dart';
import 'package:active_memory/src/features/inventory/presentation/screen/register_my_gym_machine_screen.dart';
import 'package:active_memory/src/features/inventory/presentation/view_models/my_gym_machine_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyGymDetailScreen extends ConsumerWidget {
  final int gymId;
  final String gymName; // AppBar에 띄워주기 위해 받습니다.

  const MyGymDetailScreen({
    super.key,
    required this.gymId,
    required this.gymName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final machineState = ref.watch(myGymMachineViewModelProvider(gymId));

    return Scaffold(
      appBar: AppBar(
        title: Text(gymName), // 예: "에이블짐 역삼점"
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final isAdded = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                  builder: (_) => RegisterMyGymMachineScreen(gymId: gymId)));

          if (isAdded == true) {
            // 등록에 성공해서 돌아왔다면 목록 새로고침
            ref.read(myGymMachineViewModelProvider(gymId).notifier).refresh();
          }
        },
        icon: const Icon(Icons.add),
        label: const Text("기구 등록"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: machineState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child:
              Text('기구 정보를 불러오지 못했습니다.\n$error', textAlign: TextAlign.center),
        ),
        data: (machines) {
          if (machines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 1. 시각적인 힌트를 주는 큰 아이콘
                  Icon(
                    Icons.fitness_center_rounded,
                    size: 80,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 24),

                  // 2. 메인 카피
                  Text(
                    "아직 등록된 기구가 없어요!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 3. 서브 카피 (이 행동을 왜 해야 하는지 이점 설명)
                  Text(
                    "자주 사용하는 기구를 추가하고\n나만의 의자 높이, 그립 세팅을 메모해보세요.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: machines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final machine = machines[index];
              return _buildMachineCard(context, ref, machine);
            },
          );
        },
      ),
    );
  }

  Widget _buildMachineCard(
      BuildContext context, WidgetRef ref, CustomMachine machine) {
    final muscleNames = machine.muscles.map((m) => m.name).join(', ');

    return Container(
      // 패딩은 안쪽의 InkWell 하위로 이동합니다.
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
      // 🌟 Material과 InkWell을 추가하여 카드 전체를 터치 가능하게 만듭니다!
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12), // 물결 효과가 모서리를 넘지 않도록
          onTap: () async {
            // 🌟 카드 아무 곳이나 누르면 수정 화면으로 이동!
            final isUpdated = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => RegisterMyGymMachineScreen(
                  gymId: gymId,
                  machineToEdit: machine, // 기존 데이터를 넘겨줌
                ),
              ),
            );

            // 수정 성공 시 새로고침
            if (isUpdated == true) {
              ref.read(myGymMachineViewModelProvider(gymId).notifier).refresh();
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Flexible(
                            child: Text(
                              machine.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              machine.bodyPart.name,
                              style: const TextStyle(
                                  color: AppColors.primary, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "운동: ${machine.standardExercise.name}",
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
                if (muscleNames.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "타겟: $muscleNames",
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
                if (machine.memo != null && machine.memo!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      machine.memo!,
                      style:
                          TextStyle(color: Colors.grey.shade800, fontSize: 13),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
