import 'package:flutter/material.dart';
import '../models/account.dart';
import 'power_dashboard_screen.dart';
import '../services/power_service.dart';

class OtpScreen extends StatefulWidget {
  final Account account;
  const OtpScreen({Key? key, required this.account}) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers = 
    List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = 
    List.generate(4, (index) => FocusNode());
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    final otp = _controllers.map((c) => c.text).join();
    if (otp.length != 4) return;

    setState(() => _isVerifying = true);
    try {
      // In production, verify OTP with backend
      await Future.delayed(Duration(seconds: 1)); // Mock delay
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PowerDashboardScreen(
            accountId: widget.account.accountId,
            powerService: PowerService(widget.account.token),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _isVerifying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(color: Colors.black),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nhập mã mở khóa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Vui lòng nhập mã iOTP của bạn',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(4, (index) => _buildOTPField(index)),
              ),
              SizedBox(height: 24),
              TextButton.icon(
                onPressed: _isVerifying ? null : () {
                  // Handle Face ID
                },
                icon: Icon(Icons.face),
                label: Text('Xác thực bằng Face ID'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                ),
              ),
              if (_isVerifying)
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPField(int index) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: TextStyle(fontSize: 24),
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 3) {
            _focusNodes[index + 1].requestFocus();
          }
          if (value.isNotEmpty && index == 3) {
            _verifyOtp();
          }
        },
      ),
    );
  }
}