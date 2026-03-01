import 'package:active_memory/src/common/theme/app_colors.dart';
import 'package:active_memory/src/features/inventory/presentation/view_models/inventory_command_view_model.dart';
import 'package:active_memory/src/features/reference/presentation/view_models/gym_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GymSearchScreen extends ConsumerStatefulWidget {
  const GymSearchScreen({super.key});

  @override
  ConsumerState<GymSearchScreen> createState() => _GymSearchScreenState();
}

class _GymSearchScreenState extends ConsumerState<GymSearchScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(gymSearchViewModelProvider);
    final searchNotifier = ref.read(gymSearchViewModelProvider.notifier);
    final inventoryCommandState = ref.watch(inventoryCommandViewModelProvider);
    final inventoryCommandNotifier =
        ref.read(inventoryCommandViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("체육관 찾기"),
      ),
      body: Column(
        children: [
          // 1. 검색바 (여기서는 체육관 이름 검색)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "헬스장 이름 검색 (예: 에이블짐)",
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () =>
                      searchNotifier.search(_searchController.text),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (value) => searchNotifier.search(value),
            ),
          ),

          // 2. 검색 결과 리스트
          Expanded(
            child: searchState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : searchState.gyms.isEmpty
                    ? const Center(
                        child: Text(
                          '검색 결과가 없습니다',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: searchState.gyms.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final gym = searchState.gyms[index];
                          return ListTile(
                            title: Text(
                              gym.name ?? '이름 없음',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(gym.address ?? '주소 없음'),
                            trailing: SizedBox(
                              width: 80,
                              child: ElevatedButton(
                                onPressed: inventoryCommandState.isLoading
                                    ? null
                                    : () async {
                                        try {
                                          await inventoryCommandNotifier
                                              .registerGym(
                                                  providerId: gym.providerId,
                                                  name: gym.name,
                                                  address: gym.address,
                                                  x: gym.latitude,
                                                  y: gym.longitude);

                                          // 등록 성공 처리 시
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(const SnackBar(
                                              content: Text('체육관 등록 성공'),
                                              backgroundColor: Colors.green,
                                            ));

                                            // 이전 화면으로 돌아가기
                                            Navigator.pop(context, true);
                                          }
                                        } catch (e) {
                                          if (context.mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(e.toString()),
                                                backgroundColor:
                                                    AppColors.error,
                                              ),
                                            );
                                          }
                                        }
                                      },
                                child: const Text("선택"),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
