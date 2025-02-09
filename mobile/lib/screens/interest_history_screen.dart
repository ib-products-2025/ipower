import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/interest_record.dart';
import '../services/api_service.dart';
import '../models/account.dart';

class InterestHistoryScreen extends StatefulWidget {
  final Account account;

  InterestHistoryScreen({required this.account});

  @override
  _InterestHistoryScreenState createState() => _InterestHistoryScreenState();
}

class _InterestHistoryScreenState extends State<InterestHistoryScreen> {
  final _apiService = ApiService();
  final _currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
  late Future<List<InterestRecord>> _interestRecordsFuture;

  @override
  void initState() {
    super.initState();
    _refreshInterestHistory();
  }

  void _refreshInterestHistory() {
    _interestRecordsFuture = _apiService.getInterestHistory(widget.account.accountId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Interest History'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() => _refreshInterestHistory()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() => _refreshInterestHistory()),
        child: FutureBuilder<List<InterestRecord>>(
          future: _interestRecordsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final interestRecords = snapshot.data!;
            
            if (interestRecords.isEmpty) {
              return Center(child: Text('No interest earned yet'));
            }
            
            return ListView.builder(
              itemCount: interestRecords.length,
              itemBuilder: (context, index) {
                final record = interestRecords[index];
                return ListTile(
                  leading: Icon(Icons.percent, color: Colors.blue),
                  title: Text(_currencyFormatter.format(record.amount)),
                  subtitle: Text(DateFormat.yMMMd().add_jm().format(record.timestamp)),
                  trailing: Text(
                    '${(record.rate * 100).toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}