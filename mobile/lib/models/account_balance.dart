// lib/models/account_balance.dart
class AccountBalance {
  final double balance;
  final double principalBalance;
  final double interestBalance;
  final double interestRate;
  final double tradingVolume;

  AccountBalance({
    this.balance = 0.0,
    this.principalBalance = 0.0,
    this.interestBalance = 0.0,
    this.interestRate = 0.03,
    this.tradingVolume = 0.0,
  });

  factory AccountBalance.fromJson(Map<String, dynamic> json) {
    return AccountBalance(
      balance: (json['balance'] ?? 0.0).toDouble(),
      principalBalance: (json['principal_balance'] ?? 0.0).toDouble(),
      interestBalance: (json['interest_balance'] ?? 0.0).toDouble(),
      interestRate: (json['interest_rate'] ?? 0.03).toDouble(),
      tradingVolume: (json['trading_volume'] ?? 0.0).toDouble(),
    );
  }
}