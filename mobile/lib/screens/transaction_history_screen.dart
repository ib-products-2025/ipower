import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction.dart';
import '../services/api_service.dart';
import '../models/account.dart';

class TransactionHistoryScreen extends StatefulWidget {
  final Account account;

  TransactionHistoryScreen({required this.account});

  @override
  _TransactionHistoryScreenState createState() => _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final _apiService = ApiService();
  final _currencyFormatter = NumberFormat.currency(locale: 'en_US', symbol: '\$');
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _refreshTransactions();
  }

  void _refreshTransactions() {
    _transactionsFuture = _apiService.getTransactionHistory(widget.account.accountId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Transaction History'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () => setState(() => _refreshTransactions()),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() => _refreshTransactions()),
        child: FutureBuilder<List<Transaction>>(
          future: _transactionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            final transactions = snapshot.data!;
            
            if (transactions.isEmpty) {
              return Center(child: Text('No transactions yet'));
            }
            
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[transactions.length - 1 - index];
                return ListTile(
                  leading: Icon(
                    transaction.type == 'deposit' ? Icons.add : Icons.remove,
                    color: transaction.type == 'deposit' ? Colors.green : Colors.red,
                  ),
                  title: Text(_currencyFormatter.format(transaction.amount)),
                  subtitle: Text(DateFormat.yMMMd().add_jm().format(transaction.timestamp)),
                  trailing: Text(
                    transaction.type.toUpperCase(),
                    style: TextStyle(
                      color: transaction.type == 'deposit' ? Colors.green : Colors.red,
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