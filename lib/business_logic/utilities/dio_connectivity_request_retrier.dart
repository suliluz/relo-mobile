import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';

class DioConnectvityRequestRetrier {
  final Dio dio;
  final Connectivity connectivity;

  DioConnectvityRequestRetrier({
    required this.dio,
    required this.connectivity,
  });

  Future<Response> scheduleRequestRetry(RequestOptions requestOptions) async {
    late StreamSubscription streamSubscription;
    final responseCompleter = Completer<Response>();

    streamSubscription = connectivity.onConnectivityChanged.listen((connectivityResult) {
      if(connectivityResult != ConnectivityResult.none) {
        // Ensure that only one retry happens on success
        streamSubscription.cancel();

        responseCompleter.complete(
          dio.fetch(requestOptions)
        );
      }
    });

    return responseCompleter.future;
  }
}