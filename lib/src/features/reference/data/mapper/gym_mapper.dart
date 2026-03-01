import 'package:active_memory/src/features/reference/data/dto/get_gym_response.dart';
import 'package:active_memory/src/features/reference/domain/gym/entity/gym.dart';

extension GetGymResponseMapper on GetGymResponse {
  Gym toEntity() {
    return Gym(
      providerId: providerId,
      name: name,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
