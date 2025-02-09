// lib/models/account.dart
class Account {
  final String accountId;
  final String username;
  final String phoneNumber;
  final String accountNumber;
  final String? token;

  Account({
    required this.accountId,
    required this.username,
    required this.phoneNumber,
    required this.accountNumber,
    this.token,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      accountId: json['account_id'] ?? '',
      username: json['username'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      accountNumber: json['account_number'] ?? '',
      token: json['access_token'],
    );
  }
}