import 'package:faker/faker.dart';
import 'package:relo/business_logic/models/purchased_booking_date.dart';
import 'package:relo/business_logic/models/travel_package.dart';

class PurchasedPackage {
  final TravelPackage travelPackage;
  final PurchasedBookingDate purchasedBookingDate;
  final String transactionId;

  PurchasedPackage({
    required this.travelPackage,
    required this.purchasedBookingDate,
    required this.transactionId,
  });

  // JSON to PurchasedPackage
  factory PurchasedPackage.fromJson(Map<String, dynamic> json) {
    return PurchasedPackage(
      travelPackage: TravelPackage.fromJson(json['travelPackage']),
      purchasedBookingDate: PurchasedBookingDate.fromJson(json['purchasedBookingDate']),
      transactionId: json['transactionId'],
    );
  }

  // PurchasedPackage to JSON
  Map<String, dynamic> toJson() {
    return {
      'travelPackage': travelPackage.toJson(),
      'purchasedBookingDate': purchasedBookingDate.toJson(),
      'transactionId': transactionId,
    };
  }

  // Generate fake PurchasedPackage using faker
  factory PurchasedPackage.fake() {
    final faker = Faker();

    return PurchasedPackage(
      travelPackage: TravelPackage.fake(),
      purchasedBookingDate: PurchasedBookingDate.fake(),
      transactionId: faker.guid.guid(),
    );
  }
}