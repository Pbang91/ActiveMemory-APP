import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  final String email;
  final String password;
  final String nickname;
  final String? bio;

  RegisterRequest({
    required this.email,
    required this.password,
    required this.nickname,
    this.bio,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
