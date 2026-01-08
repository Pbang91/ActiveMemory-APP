import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_me_response.g.dart';

@JsonSerializable()
class GetMeResponse {
  final int id;
  final String? email;
  final String nickname;
  final String? bio;
  final String authType;
  final String createdAt;

  GetMeResponse({
    required this.id,
    this.email,
    required this.nickname,
    this.bio,
    required this.authType,
    required this.createdAt,
  });

  factory GetMeResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMeResponseFromJson(json);
}
