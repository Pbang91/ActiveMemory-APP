import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  final String authType;
  final String? email;
  final String? password;
  final String? token;

  LoginRequest({
    required this.authType,
    this.email,
    this.password,
    this.token,
  });

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
