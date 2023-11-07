import 'dart:convert';

import '../enums/gender_item.dart';
import '../enums/verification_status.dart';

class UserProfileData {
  final String accountId;
  final String name;
  final String state;
  final String country;
  final GenderItem gender;
  final DateTime birthDate;
  final String aboutMe;
  final DateTime joinedDate;
  final bool isAgent;
  final List<String> languagesSpoken;
  late VerificationStatus? verificationStatus;
  late int? uniqueCustomers;
  late String? profilePicture;
  late double? ratingAverage;
  late int? reviewsCount;

  UserProfileData({
    required this.accountId,
    required this.name,
    required this.state,
    required this.country,
    required this.gender,
    required this.birthDate,
    required this.aboutMe,
    required this.joinedDate,
    required this.isAgent,
    required this.languagesSpoken,
    this.verificationStatus = VerificationStatus.unverified,
    this.uniqueCustomers,
    this.profilePicture,
    this.ratingAverage,
    this.reviewsCount,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = jsonDecode(jsonEncode(json));

    GenderItem gender;
    VerificationStatus verificationStatus;

    switch(data['gender']) {
      case "male":
        gender = GenderItem.male;
        break;
      case "female":
        gender = GenderItem.female;
        break;
      default:
        gender = GenderItem.other;
        break;
    }

    switch(data['verification_status']) {
      case "verified":
        verificationStatus = VerificationStatus.verified;
        break;
      case "partial":
        verificationStatus = VerificationStatus.partial;
        break;
        case "pending":
        verificationStatus = VerificationStatus.pending;
        break;
      default:
        verificationStatus = VerificationStatus.unverified;
        break;
    }

    return UserProfileData(
      accountId: data['account_id'],
      name: data['name'],
      state: data['state'],
      country: data['country'],
      gender: gender,
      birthDate: DateTime.parse(data['date_of_birth']),
      joinedDate: DateTime.parse(data['joined_date']),
      aboutMe: data['about_me'] ?? "There's no description from this user yet.",
      isAgent: data['is_agent'],
      languagesSpoken: List<String>.from(data['languages_spoken']),
      verificationStatus: verificationStatus,
      uniqueCustomers: data['unique_customers'],
      profilePicture: data['profile_picture'],
      ratingAverage: data['rating_average'],
      reviewsCount: data['reviews_count'],
    );
  }
}