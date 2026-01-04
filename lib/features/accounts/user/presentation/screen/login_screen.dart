import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 키보드가 올라왔을 때 화면이 가려지지 않게 스크롤 가능하게 만듭니다.
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Logo & Welcome Text
                const Icon(Icons.fitness_center, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                Text(
                  "Active Memory",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // 2. Email & Password Form
                // (나중에 Form 위젯과 GlobalKey로 감쌀 예정)
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: '이메일',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),

                // 3. Login Button
                ElevatedButton(
                  onPressed: () {
                    // TODO: 로그인 로직 호출
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("로그인", style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 32),

                // 4. Divider
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("SNS 계정으로 로그인",
                          style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // 5. Social Buttons (Row)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _SocialButton(
                      icon: Icons.chat_bubble, // 카카오 아이콘 대신 임시
                      color: Colors.yellow,
                      onTap: () {},
                    ),
                    const SizedBox(width: 20),
                    _SocialButton(
                      icon: Icons.g_mobiledata, // 구글 아이콘 대신 임시
                      color: Colors.white,
                      borderColor: Colors.grey,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 40),

                // 6. Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("계정이 없으신가요?"),
                    TextButton(
                      onPressed: () {
                        // [네비게이션] 회원가입 화면으로 이동
                        context.push('/signup');
                      },
                      child: const Text("회원가입"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// 소셜 버튼 컴포넌트 분리 (재사용성)
class _SocialButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color? borderColor;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.color,
    this.borderColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87),
      ),
    );
  }
}
