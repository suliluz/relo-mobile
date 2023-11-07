import 'package:relo/business_logic/models/package_information.dart';
import 'package:relo/business_logic/models/transactions.dart';
import 'package:relo/business_logic/models/travel_available_booking_dates.dart';

class PackageSubscription {
  final PackageInformation packageInformation;
  final String bookingDateId;
  final int quantity;
  final List<Transactions> transactions;
  final String accountId;

  PackageSubscription({
    required this.packageInformation,
    required this.bookingDateId,
    required this.quantity,
    required this.transactions,
    required this.accountId,
  });

   TravelBookingDates getPurchasedBookingDate() {
    return packageInformation.bookingDates.firstWhere((element) => element.bookingDateId == bookingDateId);
  }

  factory PackageSubscription.fromJson(Map<String, dynamic> json) {
    return PackageSubscription(
      packageInformation: PackageInformation.fromJson(json['travel_package']),
      bookingDateId: json['booking_date_id'],
      quantity: json['quantity'],
      transactions: json['transactions'].map((e) => Transactions.fromJson(e)).toList(),
      accountId: json['account_id'],
    );
  }
}