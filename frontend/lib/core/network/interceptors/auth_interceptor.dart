import 'dart:async';

import 'package:dio/dio.dart';

typedef TokenProvider = FutureOr<String?> Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required TokenProvider tokenProvider})
    : _tokenProvider = tokenProvider;

  final TokenProvider _tokenProvider;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    options.headers.putIfAbsent(
      Headers.acceptHeader,
      () => Headers.jsonContentType,
    );
    options.headers.putIfAbsent(
      Headers.contentTypeHeader,
      () => Headers.jsonContentType,
    );

    final String? token = await _tokenProvider();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }
}
