import 'package:relo/business_logic/enums/season_item.dart';
import 'package:relo/business_logic/utilities/credentials_manager.dart';

import '../models/purchased_package.dart';
import '../models/relo_response.dart';
import '../models/travel_package.dart';
import '../utilities/relo_http_client.dart';

class TravelService {
  static Future<ReloResponse?> getPackages({SeasonItem season = SeasonItem.all, int page = 1}) async {
    try {
      String packageSeason = "";

      switch(season) {
        case SeasonItem.spring:
          packageSeason = "spring";
          break;
          case SeasonItem.summer:
          packageSeason = "summer";
          break;
          case SeasonItem.autumn:
          packageSeason = "autumn";
          break;
          case SeasonItem.winter:
          packageSeason = "winter";
          break;
        default:
          packageSeason = "all";
          break;
      }

      // Check if user is logged in by checking if token is present
      String? token = await CredentialsManager.accessToken();

      return ReloHTTPServer.get(
        params: {
          "season": packageSeason,
          "page": page
        },
        path: "/travel/packages",
        authentication: token != null? true : false
      );

    } catch (e) {
      rethrow;
    }
  }

  static Future<ReloResponse?> getWishlist() async {
    try {
      // Check if user is logged in by checking if token is present
      String? token = await CredentialsManager.accessToken();

      if(token == null) {
        return ReloResponse(
          success: false,
          message: "You are not logged in",
        );
      }

      return ReloHTTPServer.get(
        params: {},
        path: "/travel/wishlist",
        authentication: true
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ReloResponse?> getPurchased() async {
    try {
      // Check if user is logged in by checking if token is present
      String? token = await CredentialsManager.accessToken();

      if(token == null) {
        return ReloResponse(
          success: false,
          message: "You are not logged in",
        );
      }

      return ReloHTTPServer.get(
        params: {},
        path: "/travel/purchased",
        authentication: true
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ReloResponse?> getPackageDetails(String packageId) async {
    try {
      // Check if user is logged in by checking if token is present
      String? token = await CredentialsManager.accessToken();

      return ReloHTTPServer.get(
        params: {},
        path: "/travel/packages/$packageId",
        authentication: token != null? true : false
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ReloResponse?> getPackageReviews(String packageId) async {
    try {
      return ReloHTTPServer.get(
        params: {},
        path: "/travel/packages/$packageId/reviews",
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ReloResponse?> getBookingsList(String packageId) async {
    try {
      // Check if user is logged in by checking if token is present
      String? token = await CredentialsManager.accessToken();

      if(token == null) {
        return ReloResponse(
          success: false,
          message: "You are not logged in",
        );
      }

      return ReloHTTPServer.get(
        params: {},
        path: "/travel/packages/$packageId/bookings",
        authentication: false
      );
    } catch (e) {
      rethrow;
    }
  }
}

// Mock version of the above class
class MockTravelService extends TravelService {
  static Future<ReloResponse?> getPackages({SeasonItem season = SeasonItem.all, int page = 1}) async {
    // Make 20 fakes packages
    List<Map<String, dynamic>> packages = List.generate(20, (index) => TravelPackage.fake().toJson());

    try {
      return ReloResponse(
        success: true,
        message: packages,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ReloResponse?> getWishlist() async {
    try {
      // Make 5 fakes packages
      List<Map<String, dynamic>> packages = List.generate(5, (index) => TravelPackage.fake().toJson());

      return ReloResponse(
        success: true,
        message: packages,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ReloResponse?> getPurchased() async {
    try {
      // Make 2 fakes of purchased packages
      List packages = List.generate(2, (index) => PurchasedPackage.fake().toJson());

      return ReloResponse(
        success: true,
        message: packages,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ReloResponse?> getPackageDetails(String packageId) async {
    try {
      return ReloResponse(
        success: true,
        message: TravelPackage.fake().toJson(),
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ReloResponse?> getPackageReviews(String packageId) async {
    try {
      // Make 5 fakes reviews
      List reviews = List.generate(15, (index) => TravelPackage.fake().toJson());

      return ReloResponse(
        success: true,
        message: reviews,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ReloResponse?> getBookingsList(String packageId) async {
    try {
      // Make 5 fakes reviews
      List bookings = List.generate(15, (index) => TravelPackage.fake().toJson());

      return ReloResponse(
        success: true,
        message: bookings,
      );
    } catch (e) {
      rethrow;
    }
  }
}