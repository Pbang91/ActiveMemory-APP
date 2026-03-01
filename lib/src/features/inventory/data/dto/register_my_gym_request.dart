import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_my_gym_request.g.dart';

@JsonSerializable()
class RegisterMyGymRequest {
  final String providerId;
  final String name;
  final String? roadAddress;
  final String address;
  final String? phone;
  final String x;
  final String y;

  RegisterMyGymRequest({
    required this.providerId,
    required this.name,
    this.roadAddress,
    required this.address,
    this.phone,
    required this.x,
    required this.y,
  });

  Map<String, dynamic> toJson() => _$RegisterMyGymRequestToJson(this);
}
