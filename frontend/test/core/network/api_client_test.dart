import 'package:cand_app/core/errors/app_exception.dart';
import 'package:cand_app/core/network/api_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ApiClient.execute', () {
    test('returns successful result as-is', () async {
      final ApiClient apiClient = ApiClient(dio: Dio());

      final String result = await apiClient.execute(() async => 'ok');

      expect(result, 'ok');
    });

    test('wraps DioException into AppException', () async {
      final ApiClient apiClient = ApiClient(dio: Dio());

      await expectLater(
        () => apiClient.execute<String>(() async {
          throw DioException(
            requestOptions: RequestOptions(path: '/users'),
            type: DioExceptionType.receiveTimeout,
          );
        }),
        throwsA(
          isA<AppException>().having(
            (AppException error) => error.type,
            'type',
            AppExceptionType.receiveTimeout,
          ),
        ),
      );
    });
  });
}
