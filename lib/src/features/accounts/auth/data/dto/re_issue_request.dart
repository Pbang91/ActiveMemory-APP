import 'package:freezed_annotation/freezed_annotation.dart';

part 're_issue_request.g.dart';

@JsonSerializable()
class ReIssueRequest {
  final String refreshToken;

  ReIssueRequest({required this.refreshToken});

  Map<String, dynamic> toJson() => _$ReIssueRequestToJson(this);
}
