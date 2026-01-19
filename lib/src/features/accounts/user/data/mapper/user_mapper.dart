import 'package:active_memory/src/features/accounts/user/data/dto/get_me_response.dart';
import 'package:active_memory/src/features/accounts/user/data/dto/register_request.dart';
import 'package:active_memory/src/features/accounts/user/domain/command/register_command.dart';
import 'package:active_memory/src/features/accounts/user/domain/entity/user.dart';

extension RegisterCommandMapper on RegisterCommand {
  RegisterRequest toDto() {
    return RegisterRequest(
        email: email, password: password, nickname: nickname, bio: bio);
  }
}

extension GetMeResponseMapper on GetMeResponse {
  User toEntity() {
    return User(
      id: id,
      email: email,
      nickname: nickname,
      bio: bio,
      authType: authType,
      createdAt: createdAt,
    );
  }
}
