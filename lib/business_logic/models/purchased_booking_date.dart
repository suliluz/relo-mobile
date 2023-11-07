import 'package:faker/faker.dart';
import 'package:uuid/uuid.dart';

class PurchasedBookingDate {
  final String bookingDateId;
  final String travelPackageId;
  final DateTime startDate;
  final DateTime endDate;
  final int pricePerPerson;
  final int personCount;
  final int totalPrice;

  PurchasedBookingDate({
    required this.bookingDateId,
    required this.travelPackageId,
    required this.startDate,
    required this.endDate,
    required this.pricePerPerson,
    required this.personCount,
    required this.totalPrice,
  });

  // JSON to PurchasedBookingDate
  factory PurchasedBookingDate.fromJson(Map<String, dynamic> json) {
    return PurchasedBookingDate(
      bookingDateId: json['bookingDateId'],
      travelPackageId: json['travelPackageId'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      pricePerPerson: json['pricePerPerson'],
      personCount: json['personCount'],
      totalPrice: json['totalPrice'],
    );
  }

  // PurchasedBookingDate to JSON
  Map<String, dynamic> toJson() {
    return {
      'bookingDateId': bookingDateId,
      'travelPackageId': travelPackageId,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'pricePerPerson': pricePerPerson,
      'personCount': personCount,
      'totalPrice': totalPrice,
    };
  }

  // Generate fake PurchasedBookingDate using faker
  factory PurchasedBookingDate.fake() {
    final faker = Faker();
    const uuid = Uuid();

    return PurchasedBookingDate(
      bookingDateId: uuid.v4(),
      travelPackageId: uuid.v4(),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      pricePerPerson: faker.randomGenerator.integer(1000),
      personCount: faker.randomGenerator.integer(10),
      totalPrice: faker.randomGenerator.integer(1000),
    );
  }
}