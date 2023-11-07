import 'dart:io';
import 'package:dio/dio.dart';

import 'dio_connectivity_request_retrier.dart';

class RetryOnConnectionChangeInterceptor extends Interceptor {
  final DioConnectvityRequestRetrier requestRetrier;

  RetryOnConnectionChangeInterceptor({
    required this.requestRetrier,
  });

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    // TODO: implement onError
    if(_shouldRetry(err)) {
      try {
        return requestRetrier.scheduleRequestRetry(err.requestOptions).then((value) => handler.resolve(value));
      } catch (e) {
        // Let any new error from the retrier pass through
        return e;
      }
    }

    // Let the error pass through if it's not the error we're looking for
    return err;
  }

    bool _shouldRetry(DioException err) {
      return err.type ==
          DioExceptionType.connectionError &&
          err.error != null &&
          err.error is SocketException;
    }
}