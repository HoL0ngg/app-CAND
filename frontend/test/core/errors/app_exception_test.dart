import 'dart:io';

import 'package:cand_app/core/errors/app_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException.fromDioException', () {
    test('maps socket errors to noConnection', () {
      final DioException exception = DioException(
        requestOptions: RequestOptions(path: '/health'),
        type: DioExceptionType.connectionError,
        error: const SocketException('Failed host lookup'),
      );

      final AppException result = AppException.fromDioException(exception);

      expect(result.type, AppExceptionType.noConnection);
      expect(result.message, 'No internet connection.');
    });

    test('maps bad response status and payload message', () {
      final DioException exception = DioException(
        requestOptions: RequestOptions(path: '/auth/login'),
        type: DioExceptionType.badResponse,
        response: Response<Map<String, dynamic>>(
          requestOptions: RequestOptions(path: '/auth/login'),
          statusCode: 401,
          data: <String, dynamic>{'message': 'Token expired'},
        ),
      );

      final AppException result = AppException.fromDioException(exception);

      expect(result.type, AppExceptionType.unauthorized);
      expect(result.message, 'Token expired');
      expect(result.statusCode, 401);
    });
  });
}
