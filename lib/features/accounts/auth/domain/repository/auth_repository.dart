import 'package:active_memory/features/accounts/auth/domain/command/login_command.dart';
import 'package:active_memory/features/accounts/auth/domain/model/auth_token.dart';

abstract class AuthRepository {
  Future<AuthToken> login(LoginCommand command);
}
