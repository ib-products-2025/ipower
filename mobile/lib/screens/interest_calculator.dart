// interest_calculator.dart
class PowerInterestCalculator {
  static double calculateBalanceRate(double balance) {
    if (balance < 5000000) return 0.0;
    if (balance < 500000000) return 0.003;
    if (balance < 2000000000) return 0.005;
    if (balance < 5000000000) return 0.007;
    if (balance < 10000000000) return 0.01;
    return 0.015;
  }

  static double calculateTradeRate(double tradingVolume) {
    if (tradingVolume < 500000000) return 0.005;
    if (tradingVolume < 2000000000) return 0.007;
    if (tradingVolume < 5000000000) return 0.01;
    if (tradingVolume < 10000000000) return 0.015;
    return 0.02;
  }

  static double calculateTotalRate(double balance, double tradingVolume) {
    return 0.025 + // Base rate
           calculateBalanceRate(balance) +
           calculateTradeRate(tradingVolume);
  }
} {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Header with logo
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Image.asset('assets/logo.png', width: 120),
                          SizedBox(width: 8),
                          Text(
                            'iPower - Tài khoản Nhân lãi',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Main content
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Chủ động gia tăng lãi suất cho tiền chờ đầu tư của bạn lên đến 6.0%/năm',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 24),
                          _buildFeatureButton(
                            'Tự động',
                            'Sinh lãi tự động và cập nhật hàng ngày',
                            Icons.autorenew,
                          ),
                          _buildFeatureButton(
                            'Tiện lợi',
                            'Nộp - rút 24/7, tự động quét tiền định kỳ',
                            Icons.account_balance_wallet,
                          ),
                          _buildFeatureButton(
                            'Linh hoạt',
                            'Lãi suất linh hoạt theo số dư và GTGD',
                            Icons.trending_up,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom buttons
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OTPScreen()),
                    ),
                    child: Text('Đăng ký ngay'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      primary: Colors.red,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text('Tìm hiểu thêm'),
                    style: TextButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureButton(String title, String subtitle, IconData icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.red),
        title: Text(title),
        subtitle: Text(subtitle),
      ),
    );
  }
}
