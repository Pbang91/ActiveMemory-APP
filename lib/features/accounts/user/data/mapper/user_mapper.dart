import 'package:active_memory/features/accounts/user/data/dto/register_request.dart';
import 'package:active_memory/features/accounts/user/domain/command/register_command.dart';

extension RegisterCommandMapper on RegisterCommand {
  RegisterRequest toDto() {
    return RegisterRequest(
        email: email, password: password, nickname: nickname, bio: bio);
  }
}
