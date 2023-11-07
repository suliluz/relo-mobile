import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:relo/screens/profile_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../models/relo_response.dart';

class CredentialsManager {
  static const String uuidKey = 'device-id';
  static const String accessKey = 'access-token';
  static const String refreshKey = 'refresh-token';

  static late FlutterSecureStorage secureStorage;

  static initialize() {
    if(Platform.isAndroid) {
      secureStorage = const FlutterSecureStorage(aOptions: AndroidOptions(encryptedSharedPreferences: true));
    } else {
      secureStorage = const FlutterSecureStorage();
    }
  }

  static Future<String> deviceID() async {
    // Check if the UUID has already been generated and stored
    var prefs = await SharedPreferences.getInstance();
    var storedUUID = prefs.getString(uuidKey);

    if (storedUUID != null) {
      // Return the stored UUID
      return storedUUID;
    } else {
      // Generate a new UUID
      var uuid = const Uuid().v4();

      // Store the generated UUID
      await prefs.setString(uuidKey, uuid);

      // Return the generated UUID
      return uuid;
    }
  }

  static Future<String?> accessToken() async {
    var prefs = await SharedPreferences.getInstance();

    var storedToken = prefs.getString(accessKey);

    return storedToken;
  }

  static Future<bool> setAccessToken(token) async {
    var prefs = await SharedPreferences.getInstance();

    return await prefs.setString(accessKey, token);
  }

  static Future<String?> refreshToken() async {
    var storedRefreshToken = await secureStorage.read(key: refreshKey);

    return storedRefreshToken;
  }

  static Future<bool> setRefreshToken(token) async {
    // Write refresh token
    await secureStorage.write(key: refreshKey, value: token);

    // Try checking if token is written
    var savedToken = await secureStorage.read(key: refreshKey);

    return savedToken == token;
  }

  static Future<bool> deleteRefreshToken() async {
    await secureStorage.delete(key: refreshKey);
    return true;
  }

  static Future<bool> deleteAccessToken() async {
    var prefs = await SharedPreferences.getInstance();

    return await prefs.remove(accessKey);
  }

  static Future<UserInformation?> userInformation() async {
    try {
      // HTTP request to get user info
      var response = await http.get(
        Uri.parse('https://relo.suliluz.name.my/user/profile'),
        headers: {'Authorization': 'Bearer $refreshToken'},
      );

      if (response.statusCode == 200) {
        ReloResponse reloResponse = ReloResponse.fromJson(jsonDecode(response.body));

        return UserInformation.fromJson(reloResponse.message);
      } else {
        throw Exception('Failed to get user information');
      }
    } catch (e) {
      rethrow;
    }
  }
}