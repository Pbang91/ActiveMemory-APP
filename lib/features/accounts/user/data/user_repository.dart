import 'package:active_memory/common/network/dio_client.dart';
import 'package:active_memory/features/accounts/user/data/mapper/user_mapper.dart';
import 'package:active_memory/features/accounts/user/data/user_api.dart';
import 'package:active_memory/features/accounts/user/domain/command/register_command.dart';
import 'package:active_memory/features/accounts/user/domain/entity/user.dart';
import 'package:active_memory/features/accounts/user/domain/repository/user_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

@riverpod
UserRepositoryImpl userRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  final api = UserApi(dio);
  return UserRepositoryImpl(api);
}

class UserRepositoryImpl implements UserRepository {
  final UserApi _api;

  UserRepositoryImpl(this._api);

  @override
  Future<int> register(RegisterCommand command) async {
    final request = command.toDto();

    final response = await _api.register(request);

    return response.data.userId;
  }

  @override
  Future<User> getMe() async {
    final response = await _api.getMe();

    return response.data.toEntity();
  }
}
