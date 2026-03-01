import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_user_response.g.dart';

@JsonSerializable()
class RegisterUserResponse {
  @JsonKey(name: 'userId') // 서버 필드명
  final int userId;

  RegisterUserResponse({required this.userId});

  factory RegisterUserResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterUserResponseFromJson(json);
}
