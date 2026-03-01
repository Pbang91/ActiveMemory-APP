class CustomException implements Exception {
  final String message;
  final String code;
  final String details;

  CustomException({
    required this.message,
    required this.code,
    this.details = '',
  });

  @override
  String toString() => message;
}
