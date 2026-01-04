import 'package:active_memory/features/accounts/user/data/user_repository.dart';
import 'package:active_memory/features/accounts/user/domain/command/register_command.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_up_view_model.g.dart';

@riverpod
class SignUpViewModel extends _$SignUpViewModel {
  @override
  AsyncValue<void> build() {
    return const AsyncValue.data(null);
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String nickname,
    String? bio,
  }) async {
    // 1. 로딩 상태 시작 (UI에서 스피너 돌게 함)
    state = const AsyncValue.loading();

    // 2. API 호출
    state = await AsyncValue.guard(() async {
      // 순수 Domain 객체 생성
      final command = RegisterCommand(
        email: email,
        password: password,
        nickname: nickname,
        bio: bio,
      );

      // Repository Interface 호출 -> impl이 받아줌
      final userId = await ref.read(userRepositoryProvider).register(command);

      // TODO: [자동 로그인] 여기에 AuthRepository.login() 호출 추가 예정
      // await ref.read(authRepositoryProvider).login(email, password);

      // 로그인이 성공하면 AuthProvider 상태가 변하고, Router가 알아서 페이지를 이동시킵니다.
    });
  }
}
