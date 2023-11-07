import 'dart:convert';

import 'package:faker/faker.dart';

class TravelBookingDates {
  final String bookingDateId;
  late final DateTime startingDate;
  late final DateTime endingDate;
  final int slotsTaken;
  late final int slotsTotal;
  late final int price;
  final DateTime createdAt;
  final DateTime updatedAt;

  TravelBookingDates({
    required this.bookingDateId,
    required this.startingDate,
    required this.endingDate,
    required this.slotsTaken,
    required this.slotsTotal,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TravelBookingDates.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = jsonDecode(jsonEncode(json));

    return TravelBookingDates(
      bookingDateId: data['_id'],
      startingDate: DateTime.parse(data['start_date']),
      endingDate: DateTime.parse(data['end_date']),
      slotsTaken: data['booking_count'],
      slotsTotal: data['max_booking_count'],
      price: data['price'],
      createdAt: DateTime.parse(data['created_at']),
      updatedAt: DateTime.parse(data['updated_at']),
    );
  }

  // Generate fake travel booking dates
  factory TravelBookingDates.fake() {
    return TravelBookingDates(
      bookingDateId: faker.guid.guid(),
      // Fake date with varying time
      startingDate: DateTime.now().add(Duration(days: faker.randomGenerator.integer(10))),
      endingDate: DateTime.now().add(Duration(days: faker.randomGenerator.integer(20))),
      slotsTaken: faker.randomGenerator.integer(10),
      slotsTotal: faker.randomGenerator.integer(10),
      price: faker.randomGenerator.integer(1000),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}