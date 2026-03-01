import 'package:active_memory/src/common/theme/app_colors.dart';
import 'package:active_memory/src/features/accounts/auth/presentation/view_models/auth_view_model.dart';
import 'package:active_memory/src/features/inventory/presentation/screen/my_gym_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyPageScreen extends ConsumerWidget {
  const MyPageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authViewModelProvider);
    final user = userState.valueOrNull;

    // 만약 유저 정보가 없으면 로딩 or 에러 처리
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Page"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            // [Section 1] 프로필 카드
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // 1. 큰 아바타
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      user.nickname[0].toUpperCase(),
                      style:
                          TextStyle(fontSize: 32, color: Colors.blue.shade800),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 2. 닉네임 & 이메일
                  Text(
                    user.nickname,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.email ?? '',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  // 3. Bio (한줄 소개)
                  if (user.bio != null && user.bio!.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user.bio!,
                        style: TextStyle(color: Colors.grey.shade800),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            const SizedBox(height: 30),

            // [Section 2] 메뉴 리스트 (ListTile)
            _buildMenuTile(
              icon: Icons.edit_outlined,
              title: "프로필 수정",
              onTap: () {
                // TODO: 프로필 수정 화면 이동
              },
            ),
            _buildMenuTile(
              icon: Icons.notifications_outlined,
              title: "알림 설정",
              onTap: () {},
            ),
            _buildMenuTile(
              icon: Icons.history,
              title: "내 활동 기록",
              onTap: () {},
            ),
            _buildMenuTile(
                icon: Icons.fitness_center,
                title: "내 체육관 관리",
                iconColor: AppColors.primary,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const MyGymListScreen()));
                }),

            const Divider(height: 40, thickness: 1),

            // [Section 3] 로그아웃 (위험한 기능은 빨간색)
            _buildMenuTile(
              icon: Icons.logout,
              title: "로그아웃",
              textColor: Colors.red,
              iconColor: Colors.red,
              onTap: () async {
                // 로그아웃 확인 다이얼로그 (UX)
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("로그아웃"),
                    content: const Text("정말 로그아웃 하시겠습니까?"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("취소"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("로그아웃",
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );

                if (confirm == true) {
                  // ViewModel 호출 -> 상태 변경 -> Router가 LoginScreen으로 보냄
                  await ref.read(authViewModelProvider.notifier).logout();
                }
              },
            ),
            _buildMenuTile(
              icon: Icons.person_off_outlined,
              title: "회원 탈퇴",
              textColor: Colors.grey,
              iconColor: Colors.grey,
              onTap: () {
                // TODO: 탈퇴 로직
              },
            ),
          ],
        ),
      ),
    );
  }

  // 메뉴 아이템 위젯 (재사용)
  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.black87),
      title: Text(
        title,
        style: TextStyle(color: textColor ?? Colors.black87),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
