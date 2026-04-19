import 'package:dio/dio.dart';

import '../errors/app_exception.dart';

sealed class Result<T> {
  const Result();

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  R when<R>({
    required R Function(T data) success,
    required R Function(AppException error) failure,
  }) {
    return switch (this) {
      Success<T>(data: final data) => success(data),
      Failure<T>(error: final error) => failure(error),
    };
  }
}

final class Success<T> extends Result<T> {
  const Success(this.data);

  final T data;
}

final class Failure<T> extends Result<T> {
  const Failure(this.error);

  final AppException error;
}

Future<Result<T>> runCatching<T>(Future<T> Function() action) async {
  try {
    return Success<T>(await action());
  } on AppException catch (error) {
    return Failure<T>(error);
  } on DioException catch (error, stackTrace) {
    return Failure<T>(
      AppException.fromDioException(error, stackTrace: stackTrace),
    );
  } catch (error, stackTrace) {
    return Failure<T>(
      AppException.unexpected(cause: error, stackTrace: stackTrace),
    );
  }
}
