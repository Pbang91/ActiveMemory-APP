import 'package:active_memory/common/network/dio_client.dart';
import 'package:active_memory/features/accounts/auth/data/auth_api.dart';
import 'package:active_memory/features/accounts/auth/data/mapper/auth_mapper.dart';
import 'package:active_memory/features/accounts/auth/domain/command/login_command.dart';
import 'package:active_memory/features/accounts/auth/domain/model/auth_token.dart';
import 'package:active_memory/features/accounts/auth/domain/repository/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_repository.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final api = AuthApi(dio);

  return AuthRepositoryImpl(api);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthApi _api;

  AuthRepositoryImpl(this._api);

  @override
  Future<AuthToken> login(LoginCommand command) async {
    final request = command.toDto();

    final response = await _api.login(request);

    return response.data.toModel();
  }

  @override
  Future<void> logout() async {
    await _api.logout();
  }
}
