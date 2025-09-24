class ErrorModel {
  final String? message;
  final String? error;
  final int? statusCode;

  ErrorModel({
    required this.message,
    required this.error,
    required this.statusCode,
  });

  factory ErrorModel.fromJson(Map<String, dynamic> json) {
    return ErrorModel(
      message: json['message'] as String?,
      error: json['error'] as String?,
      statusCode: json['statusCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'message': message, 'error': error, 'statusCode': statusCode};
  }
}
