import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_user_request.g.dart';

@JsonSerializable()
class RegisterUserRequest {
  final String email;
  final String password;
  final String nickname;
  final String? bio;

  RegisterUserRequest({
    required this.email,
    required this.password,
    required this.nickname,
    this.bio,
  });

  Map<String, dynamic> toJson() => _$RegisterUserRequestToJson(this);
}
