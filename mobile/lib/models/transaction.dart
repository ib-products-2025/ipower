// lib/models/transaction.dart
class Transaction {
  final String id;
  final String type;
  final double amount;
  final DateTime timestamp;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.timestamp,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      type: json['type'],
      amount: double.parse(json['amount'].toString()),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}