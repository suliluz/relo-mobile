import 'package:dio/dio.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:relo/business_logic/utilities/dio_connectivity_request_retrier.dart';
import 'package:relo/business_logic/utilities/retry_interceptor.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/relo_response.dart';
import '../providers/authentication.dart';
import 'credentials_manager.dart';
import 'custom_exceptions.dart';

class ReloHTTPServer {
  static const bool _secure = false;
  static const String _host = "127.0.0.1:3000";
  static final Dio _client = Dio();

  static String _fqdn() {
    return "${_secure? 'https' : 'http'}://$_host";
  }

  static resolve(path) {
    return "${_secure? 'https' : 'http'}://$_host/$path";
  }

  static initialize() {
    _client.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectvityRequestRetrier(
          dio: _client,
          connectivity: Connectivity(),
        ),
      ),
    );
  }

  static Future<ReloResponse?> get({required String path, required Map<String, dynamic> params, Map<String, dynamic>? headers, bool authentication = false}) async {
    try {
      // Copy headers to httpHeaders if headers is not null
      Map<String, dynamic> httpHeaders = {};
      if (headers != null) {
        httpHeaders.addAll(headers);
      }

      // If authentication is needed
      if (authentication) {
        // Check if access token exists
        String? storedRefreshToken = await CredentialsManager.refreshToken();

        // Add stored access token to httpHeaders
        httpHeaders["Authorization"] = "Bearer $storedRefreshToken";
      }

      Response response = await _client.get("$_fqdn()$path", queryParameters: params, options: Options(headers: httpHeaders));

      if(response.data == null) {
        throw NoResponseException();
      } else {
        var reloResponse = ReloResponse.fromJson(response.data);

        if(reloResponse.success) {
          return reloResponse;
        } else {
          if(reloResponse.message == "Unauthorized") {
            // Attempt to renew access token
            await Authentication.getAccessToken();
            // Try again
            return await get(path: path, params: params, authentication: authentication);
          } else if (reloResponse.message == "Error occurred.") {
            throw ServerErrorException();
          } else {
            throw CustomException(message: reloResponse.message);
          }
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<ReloResponse> post({
      required String path,
      Map<String, dynamic>? body,
      Map<String, String>? headers,
      bool authentication = true,
      Map<String, List<File>>? files,
    }) async {
      try {
        // Create a FormData object if files are provided
        FormData formData;

        if (files != null && files.isNotEmpty) {
          formData = FormData();

          // Add files to the FormData object
          for (var entry in files.entries) {
            for (var file in entry.value) {
              formData.files.add(MapEntry(entry.key, await MultipartFile.fromFile(file.path)));
            }
          }

          // Add body to the FormData object
          if (body != null) {
            for (var entry in body.entries) {
              formData.fields.add(MapEntry(entry.key, entry.value.toString()));
            }
          }

        } else {
          // Create a regular request if no files are provided
          formData = FormData.fromMap(body ?? {});
        }

        // Create a Dio client instance
        var dio = _client;

        // Add headers to the request
        if (headers != null) {
          dio.options.headers.addAll(headers);
        }

        // Add authentication token to the headers if required
        if (authentication) {
          var accessToken = await Authentication.getAccessToken();
          dio.options.headers['Authorization'] = 'Bearer $accessToken';
        }

        // Send the request
        var response = await dio.post(resolve(path), data: formData);

        // Parse the response
        if (response.statusCode == 200) {
          var reloResponse = ReloResponse.fromJson(response.data);
          if (reloResponse.success) {
            return reloResponse;
          } else {
            throw CustomException(message: reloResponse.message);
          }
        } else {
          throw ServerErrorException();
        }
      } catch (e) {
        rethrow;
      }
    }

  // Method to handle websocket connection
  static WebSocketChannel createWebSocketClient({required String path, required Function(dynamic) listenerCallback}) {
    var ws = WebSocketChannel.connect(Uri.parse("${_secure? 'wss' : 'ws'}://$_host$path"));

    ws.stream.listen(listenerCallback);

    return ws;
  }

  static close() {
    _client.close();
  }
}