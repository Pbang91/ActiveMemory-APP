import 'package:active_memory/src/features/accounts/auth/data/dto/login_request.dart';
import 'package:active_memory/src/features/accounts/auth/data/dto/login_response.dart';
import 'package:active_memory/src/features/accounts/auth/domain/command/login_command.dart';
import 'package:active_memory/src/features/accounts/auth/domain/model/auth_token.dart';

extension LoginCommandMapper on LoginCommand {
  LoginRequest toDto() {
    return LoginRequest(
      authType: authType,
      email: email,
      password: password,
      token: token,
    );
  }
}

extension LoginResponseMapper on LoginResponse {
  AuthToken toModel() {
    return AuthToken(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
