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
    final state = ref.watch(gymSearchViewModelProvider);
    final notifier = ref.read(gymSearchViewModelProvider.notifier);

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
                  onPressed: () => notifier.search(_searchController.text),
                ),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onSubmitted: (value) => notifier.search(value),
            ),
          ),

          // 2. 검색 결과 리스트
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.gyms.isEmpty
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
                        itemCount: state.gyms.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final gym = state.gyms[index];
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
                                onPressed: () async {
                                  // 등록 로직 실행
                                  // await notifier.registerGym(gym);
                                  // if (context.mounted) {
                                  //   Navigator.pop(context); // 등록 후 닫기
                                  // }
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
