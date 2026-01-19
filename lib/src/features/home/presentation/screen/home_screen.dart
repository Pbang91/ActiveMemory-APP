import 'package:active_memory/src/features/accounts/auth/presentation/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authViewModelProvider);
    final user = userState.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Memory"), // 로고 등
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. 환영 메시지 (User Domain)
            Text(
              "${user?.nickname ?? '회원'}님,\n오늘도 득근하세요! 💪",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),

            // 2. 운동 요약 카드 (Workout Domain - Placeholder)
            Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(child: Text("이번 주 운동 통계 그래프")),
            ),
            const SizedBox(height: 20),

            // 3. 바로가기 메뉴
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildShortcut(Icons.play_arrow, "운동 시작"),
                _buildShortcut(Icons.calendar_today, "루틴"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShortcut(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey.shade200,
          child: Icon(icon, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
