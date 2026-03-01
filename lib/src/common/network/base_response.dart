import 'package:freezed_annotation/freezed_annotation.dart';

part 'base_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class SuccessResponse<T> {
  final T data;

  SuccessResponse({required this.data});

  factory SuccessResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$SuccessResponseFromJson(json, fromJsonT);
}

@JsonSerializable()
class ExceptionResponse {
  final String code;
  final String description;
  final String details;

  ExceptionResponse({
    required this.code,
    required this.description,
    required this.details,
  });

  factory ExceptionResponse.fromJson(Map<String, dynamic> json) =>
      _$ExceptionResponseFromJson(json);

  @override
  String toString() => '$description ($details)';
}
