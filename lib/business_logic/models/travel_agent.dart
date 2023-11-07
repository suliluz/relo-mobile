import 'package:relo/business_logic/enums/gender_item.dart';
import 'package:faker/faker.dart';

class TravelAgent {
  final String travelAgentId;
  final String travelAgentName;
  final String travelAgentProfilePicture;
  final String travelAgentAboutMe;
  final DateTime travelAgentBirthDate;
  final GenderItem travelAgentGender;
  final List<String> spokenLanguages;
  final double travelAgentRating;
  final int reviewsCount;
  final bool isVerified;
  final DateTime joinedAt;

  TravelAgent({
    required this.travelAgentId,
    required this.travelAgentName,
    required this.travelAgentProfilePicture,
    required this.travelAgentAboutMe,
    required this.travelAgentBirthDate,
    required this.travelAgentGender,
    required this.spokenLanguages,
    required this.travelAgentRating,
    required this.reviewsCount,
    required this.isVerified,
    required this.joinedAt,
  });

  // JSON to TravelAgent
  factory TravelAgent.fromJson(Map<String, dynamic> json) {
    return TravelAgent(
      travelAgentId: json['travelAgentId'],
      travelAgentName: json['travelAgentName'],
      travelAgentProfilePicture: json['travelAgentProfilePicture'],
      travelAgentAboutMe: json['travelAgentAboutMe'],
      travelAgentBirthDate: DateTime.parse(json['travelAgentBirthDate']),
      travelAgentGender: GenderItem.values.firstWhere((element) => element.toString() == json['travelAgentGender']),
      spokenLanguages: json['spokenLanguages'].cast<String>(),
      travelAgentRating: json['travelAgentRating'],
      reviewsCount: json['reviewsCount'],
      isVerified: json['isVerified'],
      joinedAt: DateTime.parse(json['joinedAt']),
    );
  }

  // TravelAgent to JSON
  Map<String, dynamic> toJson() {
      return {
        "travelAgentId": travelAgentId,
        "travelAgentName": travelAgentName,
        "travelAgentProfilePicture": travelAgentProfilePicture,
        "travelAgentAboutMe": travelAgentAboutMe,
        "travelAgentBirthDate": travelAgentBirthDate.toIso8601String(),
        "travelAgentGender": travelAgentGender.toString(),
        "spokenLanguages": spokenLanguages,
        "travelAgentRating": travelAgentRating,
        "reviewsCount": reviewsCount,
        "isVerified": isVerified,
        "joinedAt": joinedAt.toString(),
      };
  }

  // Generate fake TravelAgent
  factory TravelAgent.fake() {
    Faker faker = Faker();

    return TravelAgent(
      travelAgentId: faker.guid.guid(),
      travelAgentName: faker.person.name(),
      travelAgentProfilePicture: faker.image.image(),
      travelAgentAboutMe: faker.lorem.sentence(),
      travelAgentBirthDate: faker.date.dateTime(),
      travelAgentGender: GenderItem.values[faker.randomGenerator.integer(2)],
      spokenLanguages: faker.randomGenerator
        .amount((_) => faker.lorem.word(), faker.randomGenerator.integer(5))
        .cast<String>(),
      travelAgentRating: faker.randomGenerator.decimal(),
      reviewsCount: faker.randomGenerator.integer(100),
      isVerified: faker.randomGenerator.boolean(),
      joinedAt: faker.date.dateTime(),
    );
  }
}