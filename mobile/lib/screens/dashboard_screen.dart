import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import '../models/account.dart';
import '../models/account_balance.dart';
import '../services/api_service.dart';
import '../models/transaction.dart';
import 'management_screen.dart';

class DashboardScreen extends StatefulWidget {
  final Account account;
  DashboardScreen({required this.account});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: 'VND',
    decimalDigits: 0,
  );
  AccountBalance? _balance;
  Timer? _interestTimer;
  bool _isDepositLoading = false;
  bool _isTradeLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchBalance();
    _startInterestPolling();
  }

  @override
  void dispose() {
    _interestTimer?.cancel();
    super.dispose();
  }

  void _startInterestPolling() {
    _interestTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _fetchBalance();
    });
  }

  Future<void> _fetchBalance() async {
    try {
      final balance = await _apiService.getBalance(widget.account.accountId);
      if (mounted) {
        setState(() {
          _balance = balance;
        });
      }
    } catch (e) {
      print('Error fetching balance: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text('Sinh lời tự động'),
        actions: [
          IconButton(
            icon: Icon(Icons.star_border),
            onPressed: () {},
          ),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBalanceSection(),
            _buildAccountInfoCard(),
            _buildActionButtons(),
            _buildTransactionHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Current Balance'),
          SizedBox(height: 8),
          Text(
            _currencyFormatter.format(_balance?.balance ?? 0),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text('Trading Volume'),
          SizedBox(height: 4),
          Text(
            _currencyFormatter.format(_balance?.tradingVolume ?? 0),
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountInfoCard() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Nickname'),
            TextButton(
              onPressed: () {},
              child: Text('Đặt nickname',
                  style: TextStyle(color: Colors.blue)),
              style: TextButton.styleFrom(padding: EdgeInsets.zero),
            ),
            SizedBox(height: 8),
            Text('Số điện thoại liên kết'),
            SizedBox(height: 4),
            Text(widget.account.phoneNumber,
                style: TextStyle(fontWeight: FontWeight.w500)),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Số tài khoản đăng ký'),
                      SizedBox(height: 4),
                      Text(widget.account.accountNumber,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.copy, color: Colors.grey),
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildActionButton(
            icon: Icons.payments,
            label: 'Nạp tiền &\nGiao dịch',
            onTap: () => _showTransactionTypeDialog(),
          ),
          _buildActionButton(
            icon: Icons.account_balance_wallet,
            label: 'Quản lý\ntài khoản',
            onTap: () {
              if (_balance != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManagementScreen(
                        balance: _balance!,
                        account: widget.account,
                        ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Icon(icon, color: Colors.blue),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _showTransactionTypeDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chọn loại giao dịch'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.add),
              title: Text('Nạp tiền'),
              onTap: () {
                Navigator.pop(context);
                _showDepositDialog(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.swap_horiz),
              title: Text('Giao dịch'),
              onTap: () {
                Navigator.pop(context);
                _showTradeDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Lịch sử giao dịch',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              IconButton(
                icon: Icon(Icons.search, color: Colors.grey),
                onPressed: () {},
              ),
            ],
          ),
        ),
        FutureBuilder<List<Transaction>>(
          future: _apiService.getTransactionHistory(widget.account.accountId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (snapshot.hasError) {
              return Center(child: Text('Error loading transactions'));
            }

            final transactions = snapshot.data ?? [];
            if (transactions.isEmpty) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Text('Chưa có giao dịch nào',
                    style: TextStyle(color: Colors.grey[600])),
              );
            }

            // Sort transactions by timestamp descending (most recent first)
            transactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

            final groupedTransactions = groupTransactionsByDate(transactions);

            return ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                String date = groupedTransactions.keys.elementAt(index);
                List<Transaction> dayTransactions = groupedTransactions[date]!;

                // Sort day transactions by timestamp descending
                dayTransactions.sort((a, b) => b.timestamp.compareTo(a.timestamp));

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        date == DateFormat('dd/MM/yyyy').format(DateTime.now())
                            ? 'Hôm nay'
                            : date,
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                    ...dayTransactions.map((transaction) => Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            transaction.type == 'deposit' ? Icons.add : Icons.remove,
                            color: transaction.type == 'deposit' ? Colors.green : Colors.red,
                          ),
                          title: Text(
                            _currencyFormatter.format(transaction.amount),
                            style: TextStyle(
                              color: transaction.type == 'deposit' ? Colors.black : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(DateFormat('HH:mm').format(transaction.timestamp)),
                          trailing: Text(
                            transaction.type == 'deposit' ? 'Nạp tiền' : 'Giao dịch',
                            style: TextStyle(
                              color: transaction.type == 'deposit' ? Colors.green : Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Divider(height: 1, indent: 72),
                      ],
                    )).toList(),
                  ],
                );
              },
            );
          },
        ),
      ],
    );
  }

  Map<String, List<Transaction>> groupTransactionsByDate(List<Transaction> transactions) {
    final grouped = <String, List<Transaction>>{};
    for (var transaction in transactions) {
      String date = DateFormat('dd/MM/yyyy').format(transaction.timestamp);
      grouped.putIfAbsent(date, () => []).add(transaction);
    }
    // Sort by date descending (newest first)
    return Map.fromEntries(
      grouped.entries.toList()..sort((e1, e2) => e2.key.compareTo(e1.key))
    );
  }

  Future<void> _showDepositDialog(BuildContext context) async {
    final TextEditingController rawAmountController = TextEditingController();
    final TextEditingController displayController = TextEditingController();

    String _formatNumber(String value) {
      String numericOnly = value.replaceAll(RegExp(r'[^\d]'), '');
      try {
        double amount = double.parse(numericOnly);
        rawAmountController.text = amount.toString();
        return _currencyFormatter.format(amount);
      } catch (e) {
        return value;
      }
    }

    return showDialog(
      context: context,
      barrierDismissible: !_isDepositLoading,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Nạp tiền'),
          content: TextFormField(
            controller: displayController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              hintText: '0',
            ),
            enabled: !_isDepositLoading,
            onChanged: (value) {
              final formatted = _formatNumber(value);
              displayController.value = TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: _isDepositLoading ? null : () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _isDepositLoading
                ? null
                : () async {
                    if (rawAmountController.text.isEmpty) return;
                    setState(() => _isDepositLoading = true);
                    try {
                      final amount = double.parse(rawAmountController.text);
                      final newBalance = await _apiService.deposit(
                        widget.account.accountId,
                        amount
                      );

                      await _fetchBalance(); // Add this line instead of manually setting balance
                      
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Nạp tiền thành công')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    } finally {
                      setState(() => _isDepositLoading = false);
                    }
                  },
              child: _isDepositLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Deposit'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showTradeDialog(BuildContext context) async {
    final TextEditingController rawAmountController = TextEditingController();
    final TextEditingController displayController = TextEditingController();

    String _formatNumber(String value) {
      String numericOnly = value.replaceAll(RegExp(r'[^\d]'), '');
      try {
        double amount = double.parse(numericOnly);
        rawAmountController.text = amount.toString();
        return _currencyFormatter.format(amount);
      } catch (e) {
        return value;
      }
    }

    return showDialog(
      context: context,
      barrierDismissible: !_isTradeLoading,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Giao dịch'),
          content: TextFormField(
            controller: displayController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Amount',
              hintText: '0',
            ),
            enabled: !_isTradeLoading,
            onChanged: (value) {
              final formatted = _formatNumber(value);
              displayController.value = TextEditingValue(
                text: formatted,
                selection: TextSelection.collapsed(offset: formatted.length),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: _isTradeLoading ? null : () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _isTradeLoading
                ? null
                : () async {
                    if (rawAmountController.text.isEmpty) return;
                    setState(() => _isTradeLoading = true);
                    try {
                      final amount = double.parse(rawAmountController.text);
                      final response = await _apiService.trade(
                        widget.account.accountId,
                        amount
                      );
                      
                      await _fetchBalance(); // Add this line instead of manually setting balance
                      
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Giao dịch thành công')),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString())),
                      );
                    } finally {
                      setState(() => _isTradeLoading = false);
                    }
                  },
              child: _isTradeLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text('Trade'),
            ),
          ],
        ),
      ),
    );
  }
}