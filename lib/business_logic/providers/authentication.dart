import 'package:dio/dio.dart';
import '../models/relo_response.dart';
import '../utilities/credentials_manager.dart';
import '../utilities/custom_exceptions.dart';
import '../utilities/relo_http_client.dart';

class Authentication {
  static Future<bool?> loginCreds(accountId, password) async {
    try {
      // Get device ID
      String deviceId = await CredentialsManager.deviceID();

      // Refresh token is provided in the message
      ReloResponse? serverResponse = await ReloHTTPServer.post(path: "/login", body: {
        "deviceId": deviceId,
        "accountId": accountId,
        "password": password
      });

      if(serverResponse != null && serverResponse.success) {
        await CredentialsManager.setRefreshToken(serverResponse.message);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool?> getAccessToken() async {
    try {
      var storedRefreshToken = await CredentialsManager.refreshToken();
      if(storedRefreshToken == null) throw RefreshTokenException();

      // If token does not exist, run a query to get new access token
      ReloResponse? serverResponse = await ReloHTTPServer.post(path: "/access-token", headers: {"Authorization": "Bearer $storedRefreshToken"}, body: {});

      // Access token is provided in the message
      if(serverResponse == null) throw ServerErrorException();

      if(serverResponse.success) {
        await CredentialsManager.setAccessToken(serverResponse.message["token"]);

        // Check if token is expiring by comparing milliseconds since epoch of current date and token time to live
        var tokenExpiryDate = serverResponse.message["expiry"];
        var currentMilliseconds = DateTime.now().millisecondsSinceEpoch;

        var tokenTTL = tokenExpiryDate - currentMilliseconds;

        // If token is expiring in less than a day, refresh token
        if(tokenTTL < 86400000) {
          await renewRefreshToken();
        }

        return true;
      } else {
        if(serverResponse.message == "Unauthorized") {
          return false;
        } else if(serverResponse.message == "Error occurred.") {
          throw ServerErrorException();
        } else {
          throw CustomException(message: serverResponse.message);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
  
  static Future<bool?> renewRefreshToken() async {
    try {
      var storedRefreshToken = await CredentialsManager.refreshToken();
      if (storedRefreshToken == null) throw RefreshTokenException();
      
      // Get device ID
      var deviceId = await CredentialsManager.deviceID();
      
      // Refresh token is provided in the message
      ReloResponse? serverResponse = await ReloHTTPServer.post(path: "/renew", body: {
        "deviceId": deviceId,
      }, headers: {"Authorization": "Bearer $storedRefreshToken"});

      if (serverResponse == null) throw NoResponseException();

      if (serverResponse.success) {
        await CredentialsManager.setRefreshToken(serverResponse.message);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<bool?> logout() async {
    try {
      // Get refresh token
      var storedRefreshToken = await CredentialsManager.refreshToken();
      if(storedRefreshToken == null) return false;

      // Get device ID
      var deviceId = await CredentialsManager.deviceID();

      // Logout request to server
      ReloResponse? serverResponse = await ReloHTTPServer.post(
          path: "/logout",
          body: {"device_id": deviceId},
          headers: {"Authorization": "Bearer $storedRefreshToken"}
      );
      
      if(serverResponse == null) throw NoResponseException();

      if(serverResponse.success) {
        // Remove refresh token and access token
        await CredentialsManager.deleteRefreshToken();
        await CredentialsManager.deleteAccessToken();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      rethrow;
    }
  }

  static Future<String?> whoami() async {
    try {
      ReloResponse? response = await ReloHTTPServer.get(path: "/whoami", params: {}, authentication: true);

      return response?.message;
    } catch (e) {
      rethrow;
    }
  }
}