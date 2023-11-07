import 'package:faker/faker.dart';

class Transactions {
  final String type;
  final String transactionStatus;
  final String amount;
  final String reference;
  final String? attachment;
  final String stripeTransactionId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Transactions({
    required this.type,
    required this.transactionStatus,
    required this.amount,
    required this.reference,
    required this.stripeTransactionId,
    required this.createdAt,
    required this.updatedAt,
    this.attachment,
  });

  factory Transactions.fromJson(Map<String, dynamic> json) {
    return Transactions(
      type: json['type'],
      transactionStatus: json['transactionStatus'],
      amount: json['amount'],
      reference: json['reference'],
      attachment: json['attachment'],
      stripeTransactionId: json['stripeTransactionId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Generate fake transaction
  factory Transactions.fake() {
    return Transactions(
      type: "Deposit",
      transactionStatus: "succeeded",
      amount: faker.randomGenerator.decimal().toString(),
      reference: faker.guid.guid(),
      attachment: null,
      stripeTransactionId: faker.guid.guid(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}