import 'dart:io';

import 'package:movie_land/core/models/failed_response_model.dart';
import 'package:movie_land/core/utils/movie_land_snackbar.dart';

class ErrorHandler {
  // Track recent errors with timestamps
  static final Map<String, DateTime> _recentErrors = {};
  static const Duration _throttleDuration = Duration(seconds: 10);

  static void handleError(Object e) {
    String message;
    bool isThrottleNeeded = true;

    if (e is FailedResponseModel) {
      final statusCode = e.statusCode;

      // Check for connection problems
      if (statusCode == 401) {
        message = 'tkoen expired'; // This should be handled separately
      } else if (e.statusMessage != null && e.statusMessage!.isNotEmpty) {
        message = e.statusMessage!;
        isThrottleNeeded = false;
      } else if (e.statusMessage != null && e.statusMessage!.isNotEmpty) {
        message = e.statusMessage!;
      } else if (statusCode == 0 || statusCode == null) {
        message = 'Connection error';
      } else {
        message = 'Operation failed ($statusCode)';
      }
    } else if (e is SocketException) {
      message = 'No Internet connection';
      final errorCode = e.osError?.errorCode;
      if (errorCode != null) message = '$message ($errorCode)';
    } else {
      // For generic errors, show unknown error message
      message = 'Unknown error occurred';
    }

    if (isThrottleNeeded) {
      // Check if this error was recently shown
      if (_isErrorThrottled(message)) {
        _recentErrors[message] = DateTime.now();
        return; // Skip showing this error
      }

      // Record this error with current timestamp
      _recentErrors[message] = DateTime.now();
    }

    // Clean up old entries periodically
    _cleanupOldErrors();

    GerdooSnackbar.showError(message: message);
  }

  // Check if an error should be throttled
  static bool _isErrorThrottled(String errorKey) {
    final lastShown = _recentErrors[errorKey];
    if (lastShown == null) {
      return false;
    }

    final timeSinceLastShown = DateTime.now().difference(lastShown);
    return timeSinceLastShown < _throttleDuration;
  }

  // Clean up old error entries to prevent memory leak
  static void _cleanupOldErrors() {
    final now = DateTime.now();
    _recentErrors.removeWhere((key, timestamp) {
      return now.difference(timestamp) > _throttleDuration;
    });
  }
}
