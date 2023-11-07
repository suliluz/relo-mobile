import 'package:faker/faker.dart';

class TravelPackageReview {
  final String reviewId;
  final String travelPackageId;
  final String userId;
  final String review;
  final int rating;
  final DateTime createdAt;

  TravelPackageReview({
    required this.reviewId,
    required this.travelPackageId,
    required this.userId,
    required this.review,
    required this.rating,
    required this.createdAt,
  });

  // JSON to TravelPackageReview
  factory TravelPackageReview.fromJson(Map<String, dynamic> json) {
    return TravelPackageReview(
      reviewId: json['reviewId'],
      travelPackageId: json['travelPackageId'],
      userId: json['userId'],
      review: json['review'],
      rating: json['rating'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  // TravelPackageReview to JSON
  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'travelPackageId': travelPackageId,
      'userId': userId,
      'review': review,
      'rating': rating,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Generate fake TravelPackageReview using faker
  factory TravelPackageReview.fake() {
    final faker = Faker();

    return TravelPackageReview(
      reviewId: faker.guid.guid(),
      travelPackageId: faker.guid.guid(),
      userId: faker.guid.guid(),
      review: faker.lorem.sentence(),
      rating: faker.randomGenerator.integer(5),
      createdAt: DateTime.now(),
    );
  }
}