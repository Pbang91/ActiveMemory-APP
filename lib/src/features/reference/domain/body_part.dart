import 'package:freezed_annotation/freezed_annotation.dart';

part 'body_part.freezed.dart'; // 불변 객체, copyWith 등 생성
part 'body_part.g.dart'; // JSON 직렬화,역직렬화 로직 생성

// DTO 데이터 모델
@freezed
class BodyPart with _$BodyPart {
  // 생성자 like Java Record
  factory BodyPart({
    required String code,
    required String name,
  }) = _BodyPart;

  // JSON -> Instance like Jackson
  factory BodyPart.fromJson(Map<String, dynamic> json) =>
      _$BodyPartFromJson(json);
}
