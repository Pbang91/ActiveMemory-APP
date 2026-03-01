import 'package:active_memory/src/features/inventory/data/dto/my_gym_response.dart';
import 'package:active_memory/src/features/inventory/data/dto/register_my_gym_request.dart';
import 'package:active_memory/src/features/inventory/domain/command/regitser_my_gym_command.dart';
import 'package:active_memory/src/features/inventory/domain/entity/my_gym.dart';

extension RegisterMyGymCommandMapper on RegisterMyGymCommand {
  RegisterMyGymRequest toDto() {
    return RegisterMyGymRequest(
        providerId: providerId, name: name, address: address, x: x, y: y);
  }
}

extension GetMyGymResponseMapper on GetMyGymResponse {
  MyGym toEntity() {
    return MyGym(myGymId: myGymId, name: name, address: address);
  }
}
