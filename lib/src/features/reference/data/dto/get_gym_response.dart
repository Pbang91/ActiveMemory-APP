import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_gym_response.g.dart';

@JsonSerializable()
class GetGymResponse {
  final String providerId;
  final String name;
  final String address;
  final String latitude;
  final String longitude;

  GetGymResponse({
    required this.providerId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory GetGymResponse.fromJson(Map<String, dynamic> json) =>
      _$GetGymResponseFromJson(json);
}
