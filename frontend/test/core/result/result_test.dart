import 'package:cand_app/core/errors/app_exception.dart';
import 'package:cand_app/core/result/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('runCatching', () {
    test('returns Success when action succeeds', () async {
      final Result<int> result = await runCatching<int>(() async => 42);

      expect(result, isA<Success<int>>());
      expect(result.when(success: (int data) => data, failure: (_) => -1), 42);
    });

    test('returns Failure when AppException is thrown', () async {
      final Result<void> result = await runCatching<void>(() async {
        throw const AppException(
          type: AppExceptionType.validation,
          message: 'Invalid payload',
        );
      });

      expect(result, isA<Failure<void>>());
      expect(
        result.when(
          success: (_) => 'success',
          failure: (AppException error) => error.message,
        ),
        'Invalid payload',
      );
    });
  });
}
