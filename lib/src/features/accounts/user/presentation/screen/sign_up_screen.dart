import 'package:active_memory/src/common/theme/app_colors.dart';
import 'package:active_memory/src/features/accounts/user/presentation/view_models/sign_up_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  bool _isPasswordVisible = false;

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

      ref.read(signUpViewModelProvider.notifier).signUp(
            email: _emailController.text,
            password: _passwordController.text,
            nickname: _nicknameController.text,
            bio: _bioController.text.isEmpty ? null : _bioController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "계정을 생성하고\nActive Memory를 시작하세요!",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.textPrimary, // 명시적 컬러 지정
                        height: 1.3, // 줄 간격
                      ),
                ),
                const SizedBox(height: 32),

                // 1. 이메일 입력
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: '이메일',
                    hintText: 'example@email.com',
                    prefixIcon: Icon(Icons.email_outlined),
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
                  decoration: InputDecoration(
                      labelText: '비밀번호',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          })),
                  obscureText: !_isPasswordVisible,
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
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 32),

                // 5. 가입 버튼
                ElevatedButton(
                  onPressed: _onSubmit,
                  child: const Text(
                    "가입하기",
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
