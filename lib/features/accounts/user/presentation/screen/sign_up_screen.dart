import 'package:active_memory/features/accounts/user/presentation/view_models/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  // 1. Form 상태 관리를 위한 Key
  final _formKey = GlobalKey<FormState>();

  // 2. 입력값 저장을 위한 Controller
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nicknameController = TextEditingController();
  final _bioController = TextEditingController();

  // 3. 리소스 정리
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nicknameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  // 4. 회원가입 버튼 클릭 시 동작
  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      // 모든 form state 유효성 검사 통과 시

      // 키보드 내리기
      FocusScope.of(context).unfocus();

      final email = _emailController.text;
      final password = _passwordController.text;
      final nickname = _nicknameController.text;
      final bio = _bioController.text;

      ref.read(signUpViewModelProvider.notifier).signUp(
            email: email,
            password: password,
            nickname: nickname,
            bio: bio.isEmpty ? null : bio,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // 뒤로가기 (로그인 화면으로)
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "계정을 생성하고\nActive Memory를 시작하세요!",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                // 1. 이메일 입력
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: '이메일',
                    hintText: 'example@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '이메일을 입력해주세요.';
                    }
                    if (!value.contains('@')) {
                      return '올바른 이메일 형식이 아닙니다.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 2. 비밀번호 입력
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: '비밀번호',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '비밀번호를 입력해주세요.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 3. 닉네임 입력
                TextFormField(
                  controller: _nicknameController,
                  decoration: const InputDecoration(
                    labelText: '닉네임',
                    hintText: '최대 20글자',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '닉네임을 입력해주세요.';
                    }
                    if (value.length > 20) {
                      return '닉네임은 20글자 이하이어야 합니다.';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // 4. 한줄 소개 (선택)
                TextFormField(
                  controller: _bioController,
                  decoration: const InputDecoration(
                    labelText: '한줄 소개 (선택)',
                    prefixIcon: Icon(Icons.description_outlined),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // 5. 가입 버튼
                ElevatedButton(
                  onPressed: _onSubmit,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    "가입하기",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
