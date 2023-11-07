import 'dart:convert';
import 'package:relo/business_logic/enums/season_item.dart';
import 'package:relo/business_logic/models/travel_available_booking_dates.dart';
import 'itinerary.dart';
import 'package:faker/faker.dart';
import 'media_upload.dart';

class PackageInformation {
  final String travelPackageId;
  final List<MediaUpload> media;
  final String name;
  final SeasonItem season;
  final String state;
  final String country;
  final double ratingAverage;
  final int ratingCount;
  final int daysCount;
  final bool customizable;
  final String tourHighlights;
  late List<Itinerary> itineraries;
  final String pdf;
  final String termsAndConditions;
  final int depositPercentage;
  final List<TravelBookingDates> bookingDates;
  final String agentId;

  PackageInformation({
    required this.travelPackageId,
    required this.media,
    required this.name,
    required this.season,
    required this.state,
    required this.country,
    required this.ratingAverage,
    required this.ratingCount,
    required this.daysCount,
    required this.customizable,
    required this.tourHighlights,
    required this.itineraries,
    required this.pdf,
    required this.termsAndConditions,
    required this.depositPercentage,
    required this.bookingDates,
    required this.agentId,
  });

  // Function to get booking date with the lowest price
  TravelBookingDates getLowestPriceBookingDate() {
    // Sort booking dates by price
    bookingDates.sort((a, b) => a.price.compareTo(b.price));

    // Return first booking date
    return bookingDates.first;
  }

  factory PackageInformation.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = jsonDecode(jsonEncode(json));

    // Get itineraries
    final List<Itinerary> itineraries = data['itineraries'].map<Itinerary>((itinerary) {
      return Itinerary(
        title: itinerary['title'],
        description: itinerary['description'],
        active: false,
      );
    }).toList();

    // Get booking dates
    final List<TravelBookingDates> bookingDates = data['booking_dates'].map<TravelBookingDates>((bookingDate) {
      return TravelBookingDates.fromJson(bookingDate);
    }).toList();

    return PackageInformation(
      travelPackageId: data['short_code'],
      media: data['media'].map<MediaUpload>((media) => MediaUpload.fromJson(media)).toList(),
      name: data['name'],
      season: SeasonItem.values.firstWhere((e) => e.toString() == 'SeasonItem.${data["season"]}'),
      state: data['state'],
      country: data['country'],
      ratingAverage: data['rating'],
      ratingCount: data['total_reviews'],
      daysCount: itineraries.length,
      customizable: data['is_customizable'],
      tourHighlights: data['tour_highlights'],
      itineraries: itineraries,
      pdf: data['pdf'],
      termsAndConditions: data['terms_and_conditions'],
      depositPercentage: data['payment_term_percent'],
      bookingDates: bookingDates,
      agentId: data['agent_id'],
    );
  }

  // Generate fake package information
  factory PackageInformation.fake() {
    final faker = Faker();

    return PackageInformation(
      travelPackageId: faker.guid.guid(),
      media: [],
      name: faker.lorem.sentence(),
      season: SeasonItem.values[faker.randomGenerator.integer(3)],
      state: faker.address.state(),
      country: faker.address.country(),
      ratingAverage: faker.randomGenerator.decimal(),
      ratingCount: faker.randomGenerator.integer(100),
      daysCount: faker.randomGenerator.integer(10),
      customizable: faker.randomGenerator.boolean(),
      tourHighlights: faker.lorem.sentence(),
      itineraries: [
        Itinerary.fake(),
        Itinerary.fake(),
        Itinerary.fake(),
        Itinerary.fake(),
        Itinerary.fake(),
      ],
      pdf: faker.image.image(),
      termsAndConditions: faker.lorem.sentence(),
      depositPercentage: faker.randomGenerator.integer(100),
      bookingDates: [
        TravelBookingDates.fake(),
        TravelBookingDates.fake(),
        TravelBookingDates.fake(),
        TravelBookingDates.fake(),
        TravelBookingDates.fake(),
      ],
      agentId: faker.guid.guid(),
    );
  }
}