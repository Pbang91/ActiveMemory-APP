import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_gym_response.g.dart';

@JsonSerializable()
class GetMyGymResponse {
  @JsonKey(name: "myGymId")
  final int myGymId;
  @JsonKey(name: "name")
  final String name;
  @JsonKey(name: "address")
  final String address;
  @JsonKey(name: "nickname")
  final String? nickname;

  GetMyGymResponse({
    required this.myGymId,
    required this.name,
    required this.address,
    this.nickname,
  });

  factory GetMyGymResponse.fromJson(Map<String, dynamic> json) =>
      _$GetMyGymResponseFromJson(json);
}
