// power_service.dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/power_models.dart';

class PowerService {
  static const String baseUrl = 'http://localhost:8000';
  final String? _token;

  PowerService(this._token);

  Future<PowerBalance> getPowerBalance(String accountId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/power/$accountId/balance'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);  
      print('Power Balance API Response: $responseBody'); // Debug print
      return PowerBalance.fromJson(json.decode(response.body));
    }
    throw Exception('Failed to get power balance');
  }

  Future<Map<String, dynamic>> deposit(String accountId, double amount) async {
    print('Making deposit API call to /power/$accountId/deposit');
    final response = await http.post(
        Uri.parse('$baseUrl/power/$accountId/deposit'),
        headers: _getHeaders(),
        body: json.encode({'amount': amount}),
    );

    if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        print('Deposit API Response: $responseBody');
        return responseBody;
    }
    throw Exception('Failed to deposit: ${response.body}');
    }

  Future<Map<String, dynamic>> withdraw(String accountId, double amount) async {
    final response = await http.post(
        Uri.parse('$baseUrl/power/$accountId/withdraw'),
        headers: _getHeaders(),
        body: json.encode({'amount': amount}),
    );

    if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);  
        print('Power Withdraw API Response: $responseBody');
        return responseBody;
    }
    throw Exception('Failed to withdraw');
    }

  // Add these methods to your PowerService class in power_service.dart

  Future<Map<String, dynamic>> getAutoTransferSettings(String accountId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/power/$accountId/auto-transfer-balances'),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      print('Power getAutoTransferSettings API Response: $data'); // Debug print   
      return json.decode(utf8.decode(response.bodyBytes));
    }
    throw Exception('Failed to get auto transfer settings');
  }

  Future<void> setAutoTransferSettings(String accountId, Map<String, dynamic> settings) async {
    final response = await http.post(
      Uri.parse('$baseUrl/power/$accountId/auto-transfer-balances'),
      headers: _getHeaders(),
      body: json.encode(settings),
    );

    if (response.statusCode != 200) {
      final errorMsg = utf8.decode(response.bodyBytes);
      throw Exception('Failed to save auto transfer settings: $errorMsg');
    }

    // Parse and check the response
    final responseData = json.decode(utf8.decode(response.bodyBytes));
    print('Power setAutoTransferSettings API Response: $responseData'); // Debug print 
    if (responseData['status'] != 'success') {
      throw Exception('Failed to save settings: ${responseData['detail'] ?? 'Unknown error'}');
    }
  }  

  Future<PowerHistory> getHistory(
    String accountId,
    DateTime startDate,
    DateTime endDate,
    String? status,
  ) async {
    final queryParams = {
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      if (status != null) 'status': status,
    };

    final response = await http.get(
      Uri.parse('$baseUrl/power/$accountId/history').replace(queryParameters: queryParams),
      headers: _getHeaders(),
    );

    if (response.statusCode == 200) {
      final decodedResponse = json.decode(utf8.decode(response.bodyBytes));
      print('Power History API Response: $decodedResponse'); // Debug print  
      return PowerHistory.fromJson(decodedResponse);  
    }
    throw Exception('Failed to get history');
  }

  Future<bool> setAutoTransfer(
    String accountId, {
    required bool enabled,
    String? depositTime,
    String? withdrawTime,
    double? minimumBalance,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/power/$accountId/auto-transfer'),
      headers: _getHeaders(),
      body: json.encode({
        'enabled': enabled,
        if (depositTime != null) 'deposit_time': depositTime,
        if (withdrawTime != null) 'withdraw_time': withdrawTime,
        if (minimumBalance != null) 'minimum_balance': minimumBalance,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }
    throw Exception('Failed to set auto transfer');
  }

  Map<String, String> _getHeaders() => {
    'Content-Type': 'application/json; charset=utf-8',
    if (_token != null) 'Authorization': 'Bearer $_token',
    };
}