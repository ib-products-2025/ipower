import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/account_balance.dart';
import '../models/account.dart';
import '../services/api_service.dart';
import 'interest_history_screen.dart';

class ManagementScreen extends StatefulWidget {
 final AccountBalance balance;
 final Account account;

 ManagementScreen({required this.balance, required this.account});

 @override
 _ManagementScreenState createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
 final ApiService _apiService = ApiService();
 final _currencyFormatter = NumberFormat.currency(
   locale: 'vi_VN',
   symbol: 'VND',
   decimalDigits: 0,
 );
 
 late AccountBalance _balance;
 bool _isLoading = false;

 @override
 void initState() {
   super.initState();
   _balance = widget.balance;
 }

 Future<void> _fetchBalance() async {
  final freshBalanceMap = await _apiService.getBalance(widget.account.accountId);
  setState(() {
    _balance = AccountBalance(
      balance: freshBalanceMap.balance,
      principalBalance: freshBalanceMap.principalBalance,
      interestBalance: freshBalanceMap.interestBalance, 
      interestRate: freshBalanceMap.interestRate,
      tradingVolume: freshBalanceMap.tradingVolume,
    );
  });
}

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.grey[100],
     appBar: AppBar(
       leading: BackButton(),
       title: Text('Quản lý Sinh lời tự động'),
       backgroundColor: Colors.white,
       elevation: 0,
     ),
     body: ListView(
       children: [
         _buildBalanceCard(context),
         _buildMenuItems(),
       ],
     ),
   );
 }

 Widget _buildBalanceCard(BuildContext context) {
   return Card(
     margin: EdgeInsets.all(16),
     elevation: 0,
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(12),
     ),
     child: Padding(
       padding: EdgeInsets.all(16),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text('Số dư sinh lời',
               style: TextStyle(color: Colors.grey[600])),
           SizedBox(height: 8),
           Text(
             _currencyFormatter.format(_balance.balance),
             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
           ),
           Divider(height: 24),
           Text('Lãi suất',
               style: TextStyle(color: Colors.grey[600])),
           SizedBox(height: 4),
           Text(
             '${(_balance.interestRate * 100).toStringAsFixed(2)}%',
             style: TextStyle(
               fontSize: 16,
               color: Colors.blue,
               fontWeight: FontWeight.w500,
             ),
           ),
           Divider(height: 24),
           Text('Tổng lợi nhuận',
               style: TextStyle(color: Colors.grey[600])),
           SizedBox(height: 4),
           Text(
             '8 Thg 1, 2025 - 21 Thg 1, 2025',
             style: TextStyle(color: Colors.grey),
           ),
           SizedBox(height: 4),
           Row(
             children: [
               Text(
                 _currencyFormatter.format(_balance.interestBalance),
                 style: TextStyle(
                   color: Colors.green,
                   fontSize: 20,
                   fontWeight: FontWeight.bold,
                 ),
               ),
               Spacer(),
               Icon(Icons.savings, color: Colors.amber, size: 24),
             ],
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             children: [
               TextButton(
                 onPressed: () async {
                   setState(() => _isLoading = true);
                   try {
                     await Navigator.push(
                       context,
                       MaterialPageRoute(
                         builder: (context) => InterestHistoryScreen(account: widget.account),
                       ),
                     );
                     await _fetchBalance();
                   } finally {
                     setState(() => _isLoading = false);
                   }
                 },
                 child: _isLoading 
                   ? SizedBox(
                       height: 16,
                       width: 16,
                       child: CircularProgressIndicator(strokeWidth: 2)
                     )
                   : Text(
                       'Xem chi tiết',
                       style: TextStyle(color: Colors.blue),
                     ),
                 style: TextButton.styleFrom(padding: EdgeInsets.zero),
               ),
               Text(
                 'Cung cấp bởi WealthCraft',
                 style: TextStyle(color: Colors.grey, fontSize: 12),
               ),
             ],
           ),
         ],
       ),
     ),
   );
 }

 Widget _buildMenuItems() {
   return Container(
     color: Colors.white,
     child: Column(
       children: [
         ListTile(
           title: Text('Cách tính lợi nhuận'),
           trailing: Icon(Icons.chevron_right),
           onTap: () {},
         ),
         Divider(height: 1, indent: 16, endIndent: 16),
         ListTile(
           title: Text('Điều khoản & Hợp đồng'),
           trailing: Icon(Icons.chevron_right),
           onTap: () {},
         ),
         Divider(height: 1, indent: 16, endIndent: 16),
         ListTile(
           title: Text('Tắt tính năng'),
           trailing: Icon(Icons.chevron_right),
           onTap: () {},
         ),
       ],
     ),
   );
 }
}