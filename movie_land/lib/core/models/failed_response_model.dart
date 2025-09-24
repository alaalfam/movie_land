import 'package:movie_land/core/models/error_model.dart';

class FailedResponseModel implements Exception {
  final String? statusMessage;
  final bool? success;
  final int statusCode;
  final Map<String, dynamic>? fieldsMapError;
  final ErrorModel? error;

  FailedResponseModel({
    required this.statusMessage,
    required this.statusCode,
    required this.success,
    this.fieldsMapError,
    this.error,
  });

  factory FailedResponseModel.fromJson(Map<String, dynamic> json) {
    return FailedResponseModel(
      statusMessage: json['status_message'] as String?,
      statusCode: json['status_code'] as int,
      success: json['success'] as bool?,
      fieldsMapError: json['fieldsMapError'] as Map<String, dynamic>?,
      error: json['error'] != null ? ErrorModel.fromJson(json['error']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status_message': statusMessage,
      'errorCode': success,
      'fieldsMapError': fieldsMapError,
      'error': error?.toJson(),
    };
  }
}
