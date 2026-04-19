import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class NetworkLogInterceptor extends Interceptor {
  NetworkLogInterceptor({this.enabled = kDebugMode});

  final bool enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (enabled) {
      developer.log(
        '${options.method} ${options.uri}',
        name: 'network.request',
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (enabled) {
      developer.log(
        '${response.statusCode} ${response.requestOptions.uri}',
        name: 'network.response',
      );
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (enabled) {
      developer.log(
        '${err.type} ${err.requestOptions.uri}',
        name: 'network.error',
        error: err,
        stackTrace: err.stackTrace,
      );
    }

    handler.next(err);
  }
}
