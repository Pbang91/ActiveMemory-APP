import 'package:active_memory/features/accounts/auth/presentation/view_models/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ReferenceScreen extends ConsumerWidget {
  const ReferenceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 현재 로그인된 유저 정보 구독
    final userState = ref.watch(authViewModelProvider);
    final user = userState.valueOrNull;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Active Memory"),
        centerTitle: false, // 왼쪽 정렬 (요즘 트렌드)
        actions: [
          // [아바타 버튼]
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () => context.push('/mypage'), // 마이페이지로 이동
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.blue.shade100,
                // 이미지가 있으면 NetworkImage, 없으면 닉네임 첫 글자
                // 현재는 이미지가 없으니 텍스트로 처리
                child: Text(
                  user?.nickname.isNotEmpty == true
                      ? user!.nickname[0].toUpperCase()
                      : "?",
                  style: TextStyle(
                    color: Colors.blue.shade800,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text("${user?.nickname}님의 운동 기록 공간"),
      ),
    );
  }
}
