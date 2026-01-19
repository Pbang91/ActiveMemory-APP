import 'package:active_memory/src/common/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../view_models/auth_view_model.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  // Form 관리를 위한 Key와 Controller
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // 로그인 버튼 클릭 시 실행될 로직
  Future<void> _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      // UX: 키보드 내리기
      FocusScope.of(context).unfocus();

      // ViewModel의 login 함수 호출
      await ref.read(authViewModelProvider.notifier).login(
            authType: 'EMAIL',
            email: _emailController.text,
            password: _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    // 상태 리스너: 에러가 발생했을 때만 스낵바를 띄움
    ref.listen(authViewModelProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('로그인 실패: ${next.error}'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    // 로딩 상태 구독: 버튼에 뺑글이 돌리기용
    final isLoading = ref.watch(authViewModelProvider).isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 로고 영역
                  const Icon(Icons.fitness_center,
                      size: 80, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    "Active Memory",
                    style: Theme.of(context).textTheme.headlineMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // 이메일 입력
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: '이메일',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        (value == null || value.isEmpty) ? '이메일을 입력해주세요' : null,
                  ),
                  const SizedBox(height: 16),

                  // 비밀번호 입력
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: '비밀번호',
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    validator: (value) => (value == null || value.isEmpty)
                        ? '비밀번호를 입력해주세요'
                        : null,
                  ),
                  const SizedBox(height: 24),

                  // 로그인 버튼 (로딩 처리 포함)
                  ElevatedButton(
                    onPressed: isLoading ? null : _onSubmit, // 로딩 중이면 클릭 방지
                    child: isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text("로그인"),
                  ),
                  const SizedBox(height: 32),

                  // Divider
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text("SNS 계정으로 로그인",
                            style: TextStyle(color: AppColors.textSecondary)),
                      ),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // TODO: Social 기능 연결
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SocialButton(
                        icon: Icons.chat_bubble,
                        color: const Color(0xFFFEE500),
                        onTap: () {},
                      ),
                      const SizedBox(width: 20),
                      _SocialButton(
                        icon: Icons.g_mobiledata,
                        color: Colors.white,
                        borderColor: Colors.grey.shade300,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),

                  // 회원가입 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("계정이 없으신가요?"),
                      TextButton(
                        onPressed: () => context.push('/signup'),
                        child: const Text(
                          "회원가입",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 소셜 버튼
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
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: borderColor != null ? Border.all(color: borderColor!) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.black87,
          size: 24,
        ),
      ),
    );
  }
}
