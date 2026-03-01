import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_my_gym_response.g.dart';

@JsonSerializable()
class RegisterMyGymResponse {
  @JsonKey(name: 'myGymId')
  final int myGymId;

  RegisterMyGymResponse({required this.myGymId});

  factory RegisterMyGymResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterMyGymResponseFromJson(json);
}
