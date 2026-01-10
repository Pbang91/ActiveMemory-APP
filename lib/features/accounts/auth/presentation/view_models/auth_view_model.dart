import 'package:active_memory/features/accounts/auth/data/auth_repository.dart';
import 'package:active_memory/features/accounts/auth/domain/command/login_command.dart';
import 'package:active_memory/features/accounts/user/data/user_repository.dart';
import 'package:active_memory/features/accounts/user/domain/entity/user.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_view_model.g.dart';

final storageProvider = Provider((ref) => const FlutterSecureStorage());

@Riverpod(keepAlive: true)
class AuthViewModel extends _$AuthViewModel {
  @override
  FutureOr<User?> build() async {
    final storage = ref.read(storageProvider);
    final accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null) {
      return null;
    }

    try {
      final user = await ref.read(userRepositoryProvider).getMe();
      return user;
    } catch (e) {
      await logout();
      return null;
    }
  }

  Future<void> login({
    required String authType,
    String? email,
    String? password,
    String? token,
  }) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final command = LoginCommand(
        authType: authType,
        email: email,
        password: password,
        token: token,
      );

      final tokens = await ref.read(authRepositoryProvider).login(command);

      final storage = ref.read(storageProvider);

      await storage.write(key: 'accessToken', value: tokens.accessToken);
      await storage.write(key: 'refreshToken', value: tokens.refreshToken);

      final user = await ref.read(userRepositoryProvider).getMe();
      return user; // user가 state가 됨
    });
  }

  Future<void> logout() async {
    try {
      await ref.read(authRepositoryProvider).logout();
    } catch (e) {
      // 여기선 뭐하지?
    }

    final storage = ref.read(storageProvider);
    await storage.deleteAll();

    state = const AsyncValue.data(null);
  }
}
