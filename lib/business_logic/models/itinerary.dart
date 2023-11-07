import 'package:faker/faker.dart';

class Itinerary {
  late String title;
  late String description;
  late bool active;

  Itinerary({
    required this.title,
    required this.description,
    this.active = false,
  });

  // JSON to Itinerary
  factory Itinerary.fromJson(Map<String, dynamic> json) {
    return Itinerary(
      title: json['title'],
      description: json['description'],
    );
  }

  // Itinerary to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
    };
  }

  // Generate fake Itinerary
  factory Itinerary.fake() {
    final faker = Faker();

    return Itinerary(
      title: faker.lorem.sentence(),
      description: faker.lorem.sentences(3).join(' '),
    );
  }
}