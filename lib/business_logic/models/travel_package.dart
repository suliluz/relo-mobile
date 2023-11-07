import 'package:relo/business_logic/enums/season_item.dart';
import 'package:faker/faker.dart';
import 'package:relo/business_logic/models/itinerary.dart';

class TravelPackage {
  final String travelPackageId;
  final String travelPackageName;
  final String travelPackageShortCode;
  final bool isWishlisted;
  final Map<String, String> media;
  final SeasonItem season;
  final String city;
  final String country;
  final bool customizable;
  final String pdfId;
  final int priceLowest;
  final String tourHighlights;
  final List<Itinerary> itinerary;
  final String termsAndConditions;
  final String agentId;

  TravelPackage({
    required this.travelPackageId,
    required this.travelPackageShortCode,
    required this.isWishlisted,
    required this.media,
    required this.season,
    required this.city,
    required this.country,
    required this.customizable,
    required this.pdfId,
    required this.priceLowest,
    required this.tourHighlights,
    required this.itinerary,
    required this.termsAndConditions,
    required this.agentId,
  });

  // JSON to TravelPackage
  factory TravelPackage.fromJson(Map<String, dynamic> json) {
    return TravelPackage(
      travelPackageId: json['travelPackageId'],
      travelPackageShortCode: json['travelPackageShortCode'],
      isWishlisted: json['isWishlisted'],
      media: json['media'],
      season: SeasonItem.values.firstWhere((element) => element.toString() == json['season']),
      city: json['city'],
      country: json['country'],
      customizable: json['customizable'],
      pdfId: json['pdfId'],
      priceLowest: json['priceLowest'],
      tourHighlights: json['tourHighlights'],
      itinerary: json['itinerary'].map<Itinerary>((itinerary) => Itinerary.fromJson(itinerary)).toList(),
      termsAndConditions: json['termsAndConditions'],
      agentId: json['agentId'],
    );
  }

  // TravelPackage to JSON
  Map<String, dynamic> toJson() {
    return {
      'travelPackageId': travelPackageId,
      'travelPackageShortCode': travelPackageShortCode,
      'isWishlisted': isWishlisted,
      'media': media,
      'season': season.toString(),
      'city': city,
      'country': country,
      'customizable': customizable,
      'pdfId': pdfId,
      'priceLowest': priceLowest,
      'tourHighlights': tourHighlights,
      'itinerary': itinerary.map((itinerary) => itinerary.toJson()).toList(),
      'termsAndConditions': termsAndConditions,
      'agentId': agentId,
    };
  }

  // Generate fake data using faker
  factory TravelPackage.fake() {
    Faker faker = Faker();

    return TravelPackage(
      travelPackageId: faker.guid.guid(),
      travelPackageShortCode: faker.guid.guid(),
      isWishlisted: faker.randomGenerator.boolean(),
      media: {
        "cover": faker.image.image(),
        "gallery": faker.image.image(),
      },
      season: SeasonItem.values[faker.randomGenerator.integer(3)],
      city: faker.address.city(),
      country: faker.address.country(),
      customizable: faker.randomGenerator.boolean(),
      pdfId: faker.guid.guid(),
      priceLowest: faker.randomGenerator.integer(1000),
      tourHighlights: faker.lorem.sentence(),
      itinerary: List.generate(3, (index) => Itinerary.fake()),
      termsAndConditions: faker.lorem.sentence(),
      agentId: faker.guid.guid(),
    );
  }
}