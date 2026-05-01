class AppException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? errors;

  const AppException({required this.message, this.statusCode, this.errors});

  @override
  String toString() => message;
}
