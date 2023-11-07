import 'package:dio/dio.dart';
import 'dart:io';
import '../models/relo_response.dart';
import '../utilities/relo_http_client.dart';

class Upload {
  static Future<ReloResponse?> uploadSingle(String nonce, File file) async {
      try {
        FormData formData = FormData.fromMap({
          "file": await MultipartFile.fromFile(file.path)
        });

        return await ReloHTTPServer.post(path: "/upload/single", body: formData, authentication: true);
      } catch (e) {
        rethrow;
      }
  }

  static Future<ReloResponse?> uploadMultiple(String nonce, List<List<int>> files) async {
      try {
        List<MultipartFile> multipartArray = [];

        for(var file in files) {
          multipartArray.add(MultipartFile.fromBytes(file));
        }

        FormData formData = FormData.fromMap({
          "files": multipartArray
        });

        return await ReloHTTPServer.post(path: "/upload/multiple", body: formData, authentication: true);
      } catch (e) {
        rethrow;
      }
  }

  static Future<String?> generateNonce(int itemLength) async {
      try {
        var serverResponse = await ReloHTTPServer.post(path: "/upload/nonce", body: {
          "item_length": itemLength
        });

        if(serverResponse != null && serverResponse.success) {
          return serverResponse.message;
        } else {
          return null;
        }
      } catch (e) {
        rethrow;
      }
  }
}