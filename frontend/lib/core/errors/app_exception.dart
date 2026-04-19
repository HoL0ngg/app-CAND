import 'dart:io';

import 'package:dio/dio.dart';

enum AppExceptionType {
  cancelled,
  connectionTimeout,
  sendTimeout,
  receiveTimeout,
  badCertificate,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  server,
  noConnection,
  unexpected,
}

class AppException implements Exception {
  const AppException({
    required this.type,
    required this.message,
    this.statusCode,
    this.cause,
    this.stackTrace,
  });

  factory AppException.fromDioException(
    DioException exception, {
    StackTrace? stackTrace,
  }) {
    switch (exception.type) {
      case DioExceptionType.cancel:
        return AppException(
          type: AppExceptionType.cancelled,
          message: 'Request was cancelled.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: stackTrace,
        );
      case DioExceptionType.connectionTimeout:
        return AppException(
          type: AppExceptionType.connectionTimeout,
          message: 'Connection timed out.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: stackTrace,
        );
      case DioExceptionType.sendTimeout:
        return AppException(
          type: AppExceptionType.sendTimeout,
          message: 'Sending data timed out.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: stackTrace,
        );
      case DioExceptionType.receiveTimeout:
        return AppException(
          type: AppExceptionType.receiveTimeout,
          message: 'Receiving data timed out.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: stackTrace,
        );
      case DioExceptionType.badCertificate:
        return AppException(
          type: AppExceptionType.badCertificate,
          message: 'Bad SSL certificate.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: stackTrace,
        );
      case DioExceptionType.badResponse:
        return AppException.fromStatusCode(
          exception.response?.statusCode,
          message: _extractMessage(exception.response?.data),
          cause: exception,
          stackTrace: stackTrace,
        );
      case DioExceptionType.connectionError:
        return AppException(
          type: exception.error is SocketException
              ? AppExceptionType.noConnection
              : AppExceptionType.unexpected,
          message: exception.error is SocketException
              ? 'No internet connection.'
              : 'Connection failed.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: stackTrace,
        );
      case DioExceptionType.unknown:
        if (exception.error is SocketException) {
          return AppException(
            type: AppExceptionType.noConnection,
            message: 'No internet connection.',
            statusCode: exception.response?.statusCode,
            cause: exception,
            stackTrace: stackTrace,
          );
        }

        return AppException(
          type: AppExceptionType.unexpected,
          message: exception.message ?? 'Unexpected network error.',
          statusCode: exception.response?.statusCode,
          cause: exception,
          stackTrace: stackTrace,
        );
    }
  }

  factory AppException.fromStatusCode(
    int? statusCode, {
    String? message,
    Object? cause,
    StackTrace? stackTrace,
  }) {
    final AppExceptionType type;
    final String fallbackMessage;

    if (statusCode == 400 || statusCode == 422) {
      type = AppExceptionType.validation;
      fallbackMessage = 'Submitted data is invalid.';
    } else if (statusCode == 401) {
      type = AppExceptionType.unauthorized;
      fallbackMessage = 'Authentication is required.';
    } else if (statusCode == 403) {
      type = AppExceptionType.forbidden;
      fallbackMessage = 'You do not have permission to access this resource.';
    } else if (statusCode == 404) {
      type = AppExceptionType.notFound;
      fallbackMessage = 'Requested resource was not found.';
    } else if (statusCode == 409) {
      type = AppExceptionType.conflict;
      fallbackMessage = 'Request conflicts with current server state.';
    } else if (statusCode != null && statusCode >= 500) {
      type = AppExceptionType.server;
      fallbackMessage = 'Server error occurred.';
    } else {
      type = AppExceptionType.unexpected;
      fallbackMessage = 'Unexpected error occurred.';
    }

    return AppException(
      type: type,
      message: message == null || message.trim().isEmpty
          ? fallbackMessage
          : message,
      statusCode: statusCode,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  factory AppException.unexpected({
    String message = 'Unexpected error occurred.',
    Object? cause,
    StackTrace? stackTrace,
  }) {
    return AppException(
      type: AppExceptionType.unexpected,
      message: message,
      cause: cause,
      stackTrace: stackTrace,
    );
  }

  final AppExceptionType type;
  final String message;
  final int? statusCode;
  final Object? cause;
  final StackTrace? stackTrace;

  @override
  String toString() {
    return 'AppException(type: $type, statusCode: $statusCode, '
        'message: $message)';
  }

  static String? _extractMessage(Object? data) {
    if (data is Map<String, dynamic>) {
      final dynamic message = data['message'] ?? data['error'];
      if (message is String && message.trim().isNotEmpty) {
        return message;
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data;
    }

    return null;
  }
}
