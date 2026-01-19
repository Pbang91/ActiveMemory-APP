import 'package:active_memory/src/features/accounts/user/domain/command/register_command.dart';
import 'package:active_memory/src/features/accounts/user/domain/entity/user.dart';

abstract class UserRepository {
  Future<int> register(RegisterCommand command);
  Future<User> getMe();
}
