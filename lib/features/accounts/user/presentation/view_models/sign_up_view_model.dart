import 'package:active_memory/features/accounts/auth/presentation/view_models/auth_view_model.dart';
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
      await ref.read(userRepositoryProvider).register(command);

      await ref.read(authViewModelProvider.notifier).login(
            authType: 'EMAIL',
            email: email,
            password: password,
          );
    });
  }
}
