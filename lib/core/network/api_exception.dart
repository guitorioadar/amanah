import 'package:dio/dio.dart';

/// The kind of failure a repository surfaces to the UI. Widgets switch on this
/// to pick the right design-system error state (toast, inline, full-screen).
enum ApiErrorType { network, timeout, server, unauthorized, validation, unknown }

/// Typed exception thrown by repositories. No raw [DioException] ever reaches a
/// widget — the network layer maps everything into this.
class ApiException implements Exception {
  const ApiException(
    this.type,
    this.message, {
    this.statusCode,
    this.fieldErrors,
  });

  /// Maps a [DioException] into a user-safe [ApiException].
  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const ApiException(
          ApiErrorType.timeout,
          'The connection timed out. Please try again.',
        );
      case DioExceptionType.connectionError:
        return const ApiException(
          ApiErrorType.network,
          'No internet connection.',
        );
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        if (code == 401 || code == 403) {
          return ApiException(
            ApiErrorType.unauthorized,
            'Your session has expired. Please sign in again.',
            statusCode: code,
          );
        }
        if (code == 422 || code == 400) {
          return ApiException(
            ApiErrorType.validation,
            'Please check the highlighted fields.',
            statusCode: code,
          );
        }
        return ApiException(
          ApiErrorType.server,
          'Something went wrong on our end. Please try again.',
          statusCode: code,
        );
      case DioExceptionType.cancel:
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const ApiException(
          ApiErrorType.unknown,
          'Something went wrong. Please try again.',
        );
    }
  }

  final ApiErrorType type;
  final String message;
  final int? statusCode;

  /// Per-field messages for [ApiErrorType.validation] (e.g. form errors).
  final Map<String, String>? fieldErrors;

  @override
  String toString() => 'ApiException($type, $statusCode): $message';
}
