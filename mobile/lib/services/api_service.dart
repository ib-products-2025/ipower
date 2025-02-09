import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/account.dart';
import '../models/account_balance.dart';
import '../models/transaction.dart';
import '../models/interest_record.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000';
  String? _token;

  Future<Account> login(String username, String password) async {
    final response = await http.post(
        Uri.parse('$baseUrl/token'),
        body: {
        'username': username,
        'password': password,
        },
    );

    if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Account.fromJson(data);
    }
    throw Exception('Login failed');
    }

  Future<Account> register({
    required String username, 
    required String password
    }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/user/register'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return Account.fromJson(json.decode(response.body));
    } else {
      throw Exception(json.decode(response.body)['detail'] ?? 'Registration failed');
    }
  }

  Future<AccountBalance> getBalance(String accountId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/account/$accountId/balance'),
      headers: _token != null ? {'Authorization': 'Bearer $_token'} : {},
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print('Balance API Response: $responseBody'); // Debug print
      return AccountBalance.fromJson(responseBody);
    } else {
      throw Exception(json.decode(response.body)['detail'] ?? 'Failed to get balance');
    }
  }

  Future<double> deposit(String accountId, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/$accountId/deposit'),
      headers: {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
      body: json.encode({'amount': amount}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)['new_balance'];
    } else {
      throw Exception(json.decode(response.body)['detail'] ?? 'Failed to deposit');
    }
  }

  Future<Map<String, dynamic>> trade(String accountId, double amount) async {
    final response = await http.post(
      Uri.parse('$baseUrl/account/$accountId/trade'),
      headers: {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      },
      body: json.encode({'amount': amount}),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      print('Trade API Response: $responseBody');
      return {
        'new_balance': responseBody['new_balance'],
        'trading_volume': responseBody['trading_volume']
      };
    } else {
      throw Exception(json.decode(response.body)['detail'] ?? 'Failed to trade');
    }
  }

  Future<List<Transaction>> getTransactionHistory(String accountId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/account/$accountId/transactions'),
      headers: _token != null ? {'Authorization': 'Bearer $_token'} : {},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Transaction.fromJson(json)).toList();
    } else {
      throw Exception(json.decode(response.body)['detail'] ?? 'Failed to get transactions');
    }
  }

  Future<List<InterestRecord>> getInterestHistory(String accountId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/account/$accountId/interest-history'),
      headers: _token != null ? {'Authorization': 'Bearer $_token'} : {},
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => InterestRecord.fromJson(json)).toList();
    } else {
      throw Exception(json.decode(response.body)['detail'] ?? 'Failed to get interest history');
    }
  }
}