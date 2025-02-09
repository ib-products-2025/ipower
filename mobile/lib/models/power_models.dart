// power_models.dart
import 'dart:convert';

double getDoubleFromJson(dynamic value) {
        if (value == null) return 0.0;
        if (value is double) return value;
        if (value is int) return value.toDouble();
        if (value is String) return double.tryParse(value) ?? 0.0;
        return 0.0;
    }

class PowerBalance {
  final double balance;
  final double interestBalance;
  final double interestRate;
  final double tradingVolume;
  final double availableBalance;  // Changed from availableAmount
  final double blockedBalance;    // Changed from blockedAmount

  PowerBalance({
    required this.balance,
    required this.interestBalance,
    required this.interestRate,
    required this.tradingVolume,
    required this.availableBalance,
    required this.blockedBalance,
  });

    factory PowerBalance.fromJson(Map<String, dynamic> json) {
    return PowerBalance(
        balance: getDoubleFromJson(json['balance']),
        interestBalance: getDoubleFromJson(json['interest_balance']),
        interestRate: getDoubleFromJson(json['interest_rate']),
        tradingVolume: getDoubleFromJson(json['trading_volume']),
        availableBalance: getDoubleFromJson(json['available_balance']),
        blockedBalance: getDoubleFromJson(json['blocked_balance']),
    );
    }
}

class PowerTransaction {
  final String id;
  final String type;
  final double amount;
  final DateTime timestamp;
  final String status;

  PowerTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.timestamp,
    required this.status,
  });

  factory PowerTransaction.fromJson(Map<String, dynamic> json) {
    return PowerTransaction(
      id: json['id'].toString(),
      type: json['type'],
      amount: getDoubleFromJson(json['amount']),
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'] ?? 'Thành công',
    );
  }
}

class PowerHistory {
  final List<PowerTransaction> transactions;
  final List<PowerInterest> interestRecords;

  PowerHistory({
    required this.transactions,
    required this.interestRecords,
  });

  factory PowerHistory.fromJson(Map<String, dynamic> json) {
    return PowerHistory(
        transactions: (json['transactions'] as List?)?.map((t) => PowerTransaction.fromJson(t)).toList() ?? [],
        interestRecords: (json['interest_records'] as List?)?.map((i) => PowerInterest.fromJson(i)).toList() ?? [],
    );
    }
}

class PowerInterest {
  final String id;
  final double amount;
  final double rate;
  final DateTime timestamp;
  final double balanceRate;
  final double tradingVolumeRate;

  PowerInterest({
    required this.id,
    required this.amount,
    required this.rate,
    required this.timestamp,
    required this.balanceRate,
    required this.tradingVolumeRate,
  });

  factory PowerInterest.fromJson(Map<String, dynamic> json) {
    return PowerInterest(
      id: json['id']?.toString() ?? '', // Handle null id
      amount: (json['amount'] ?? 0.0).toDouble(), // Handle null amount
      rate: (json['rate'] ?? 0.0).toDouble(), // Handle null rate
      timestamp: DateTime.parse(json['timestamp'] ?? DateTime.now().toIso8601String()), // Handle null timestamp
      balanceRate: (json['balance_rate'] ?? 0.0).toDouble(), // Handle null balanceRate
      tradingVolumeRate: (json['trading_volume_rate'] ?? 0.0).toDouble(), // Handle null tradingVolumeRate
    );
  }
}