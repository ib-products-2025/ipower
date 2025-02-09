class InterestRecord {
  final String id;
  final double amount;
  final double rate;
  final DateTime timestamp;

  InterestRecord({
    required this.id,
    required this.amount,
    required this.rate,
    required this.timestamp,
  });

  factory InterestRecord.fromJson(Map<String, dynamic> json) {
    return InterestRecord(
      id: json['id'],
      amount: double.parse(json['amount'].toString()),
      rate: double.parse(json['rate'].toString()),
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}