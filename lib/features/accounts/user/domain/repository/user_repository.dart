import 'package:active_memory/features/accounts/user/domain/command/register_command.dart';

abstract class UserRepository {
  Future<int> register(RegisterCommand command);
}
