import 'package:flutter/material.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
 const WelcomeScreen({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Colors.white,
     body: SafeArea(
       child: Column(
         children: [
           Expanded(
             child: SingleChildScrollView(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.stretch,
                 children: [
                   _buildHeader(),
                   _buildMainContent(),
                 ],
               ),
             ),
           ),
           _buildBottomButtons(context),
         ],
       ),
     ),
   );
 }

 Widget _buildHeader() {
   return Container(
     padding: EdgeInsets.all(16),
     child: Row(
       children: [
         Icon(Icons.account_balance_wallet, size: 40, color: Colors.red),
         SizedBox(width: 12),
         Expanded(
           child: Text(
             'iEarn - Tích luỹ thông minh',
             style: TextStyle(
               fontSize: 20,
               fontWeight: FontWeight.bold,
             ),
           ),
         ),
         IconButton(
           icon: Icon(Icons.close),
           onPressed: () {},
         ),
       ],
     ),
   );
 }

 Widget _buildMainContent() {
   return Padding(
     padding: EdgeInsets.all(16),
     child: Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Text(
           'Chủ động gia tăng lãi suất cho tiền chờ đầu tư của bạn lên đến 6.0%/năm',
           style: TextStyle(
             fontSize: 18,
             fontWeight: FontWeight.w500,
             height: 1.5,
           ),
         ),
         SizedBox(height: 32),
         _buildFeatureItem(
           icon: Icons.autorenew,
           title: 'Tự động',
           description: 'Sinh lãi tự động và cập nhật hàng ngày',
         ),
         SizedBox(height: 16),
         _buildFeatureItem(
           icon: Icons.account_balance_wallet,
           title: 'Tiện lợi',
           description: 'Nộp - rút 24/7, tự động quét tiền định kỳ và tính vào sức mua cổ phiếu',
         ),
         SizedBox(height: 16),
         _buildFeatureItem(
           icon: Icons.trending_up,
           title: 'Linh hoạt',
           description: 'Lãi suất linh hoạt theo số dư và giá trị giao dịch lên đến 6.0%/năm',
         ),
       ],
     ),
   );
 }

 Widget _buildFeatureItem({
   required IconData icon,
   required String title,
   required String description,
 }) {
   return Container(
     padding: EdgeInsets.all(16),
     decoration: BoxDecoration(
       color: Colors.red.withOpacity(0.1),
       borderRadius: BorderRadius.circular(12),
     ),
     child: Row(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Icon(icon, color: Colors.red, size: 24),
         SizedBox(width: 16),
         Expanded(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 title,
                 style: TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                 ),
               ),
               SizedBox(height: 4),
               Text(
                 description,
                 style: TextStyle(
                   color: Colors.black87,
                   height: 1.4,
                 ),
               ),
             ],
           ),
         ),
       ],
     ),
   );
 }

 Widget _buildBottomButtons(BuildContext context) {
   return Container(
     padding: EdgeInsets.all(16),
     decoration: BoxDecoration(
       color: Colors.white,
       boxShadow: [
         BoxShadow(
           color: Colors.black.withOpacity(0.05),
           offset: Offset(0, -4),
           blurRadius: 8,
         ),
       ],
     ),
     child: Column(
       mainAxisSize: MainAxisSize.min,
       crossAxisAlignment: CrossAxisAlignment.stretch,
       children: [
         ElevatedButton(
           onPressed: () => Navigator.push(
             context,
             MaterialPageRoute(builder: (context) => RegisterScreen()),
           ),
           child: Text(
             'Đăng ký ngay',
             style: TextStyle(
               fontSize: 16,
               fontWeight: FontWeight.bold,
             ),
           ),
         ),
         SizedBox(height: 12),
         TextButton(
           onPressed: () {},
           child: Text('Tìm hiểu thêm'),
           style: TextButton.styleFrom(
             foregroundColor: Colors.blue,
           ),
         ),
       ],
     ),
   );
 }
}