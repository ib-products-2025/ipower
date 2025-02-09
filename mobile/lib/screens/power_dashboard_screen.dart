import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/power_models.dart';
import '../services/power_service.dart';
import 'power_history_screen.dart';
import 'info_modal.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'auto_transfer_settings_modal.dart';

class DetailsModal extends StatelessWidget {
  final VoidCallback onClose;

  const DetailsModal({Key? key, required this.onClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Lãi suất iEarn',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // First table
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(8),
                5: FlexColumnWidth(1),
              },
              children: [
                TableRow(
                  children: [
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                    const SizedBox.shrink(),
                    TableCell(
                      verticalAlignment: TableCellVerticalAlignment.middle,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: const Text(
                          'Giá trị giao dịch luỹ kế tháng',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox.shrink(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Second table
            Table(
              columnWidths: const {
                0: FlexColumnWidth(5),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(2),
                3: FlexColumnWidth(2),
                4: FlexColumnWidth(2),
                5: FlexColumnWidth(2),
              },
              children: [
                TableRow(
                  children: [
                    const TableCell(
                      child: Text(
                        'Số dư',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const TableCell(
                      child: Text(
                        'Từ < 500tr',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const TableCell(
                      child: Text(
                        'Từ 500tr đến < 2 ty',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const TableCell(
                      child: Text(
                        'Từ 2 ty đến < 5 ty',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const TableCell(
                      child: Text(
                        'Từ 5 ty đến < 10 ty',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                    const TableCell(
                      child: Text(
                        'Từ 10 ty trở lên',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('Nhỏ hơn 500tr'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('3.3%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('3.5%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('3.8%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('4.3%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('4.8%'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('Từ 500tr đến < 2 ty'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('3.5%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('3.7%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('4.0%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('4.5%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('5.0%'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('Từ 2 ty đến < 5 ty'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('3.7%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('3.9%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('4.2%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('4.7%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('5.2%'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('Từ 5 ty đến < 10 ty'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('4.0%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('4.2%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('4.5%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('5.0%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('5.5%'),
                    ),
                  ],
                ),
                TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('Trên 10 ty'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('4.5%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('4.7%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('5.0%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('5.5%'),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: const Text('6.0%'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Lưu ý: Lãi suất iEarn chỉ áp dụng khi số dư iEarn đạt tối thiểu 5 triệu đồng và tối đa 60 tỷ đồng.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: onClose,
                  child: const Text('Đóng'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PowerDashboardScreen extends StatefulWidget {
  final String accountId;
  final PowerService powerService;

  const PowerDashboardScreen({
    Key? key,
    required this.accountId,
    required this.powerService,
  }) : super(key: key);

  @override
  _PowerDashboardScreenState createState() => _PowerDashboardScreenState();
}

class _PowerDashboardScreenState extends State<PowerDashboardScreen> {
  late Future<PowerBalance> _balanceFuture;
  final _depositController = TextEditingController();
  final _withdrawController = TextEditingController();
  bool _isPowerEnabled = false;
  bool _isAutoTransferEnabled = false;
  String _selectedDepositAccount = 'Thường';
  String _selectedWithdrawAccount = 'Thường';
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);
  Timer? _balanceTimer;
  bool _isLoading = false;
  bool _isVerifying = false;
  Map<String, dynamic>? _autoTransferSettings;

  @override
  void initState() {
    super.initState();
    _balanceFuture = widget.powerService.getPowerBalance(widget.accountId);
    _startBalanceTimer();
    _loadAutoTransferSettings(); // Add this
  }

  void _startBalanceTimer() {
    _balanceTimer = Timer.periodic(Duration(minutes: 1), (timer) {
      _loadBalance();
    });
  }

  Future<void> _loadAutoTransferSettings() async {
    try {
      final settings = await widget.powerService.getAutoTransferSettings(widget.accountId);
      setState(() {
        _autoTransferSettings = settings;
        _isAutoTransferEnabled = settings['enabled'] ?? false;
      });
    } catch (e) {
      print('Error loading auto transfer settings: $e');
    }
  }

  Future<void> _handleAutoTransferSwitch(bool value) async {
    try {
      // Create settings object with current or default values
      final settings = {
        'enabled': value,
        'transfer_option': _autoTransferSettings?['transfer_option'] ?? 'Nộp',
        'balances': _autoTransferSettings?['balances'] ?? {
          'TK Thường': 1000000,
          'TK Ký quỹ': 1000000,
          'TK Phái sinh': 0,
        },
      };

      // Send request to update settings
      await widget.powerService.setAutoTransferSettings(
        widget.accountId,
        settings,
      );

      // Update local state after successful API call
      setState(() => _isAutoTransferEnabled = value);
      
      // Reload settings to ensure UI is in sync with backend
      await _loadAutoTransferSettings();
    } catch (e) {
      print('Error updating auto transfer state: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể cập nhật trạng thái: $e')),
      );
      // Revert the switch if there was an error
      setState(() => _isAutoTransferEnabled = !value);
    }
  }

  Future<void> _loadBalance() async {
    setState(() => _isLoading = true);
    try {
      final balance = await widget.powerService.getPowerBalance(widget.accountId);
      setState(() {
        _balanceFuture = Future.value(balance); // Update _balanceFuture
      });
    } catch (e) {
      print('Error loading balance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải số dư: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Helper function to format the input as currency
  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    // Remove all non-numeric characters
    String numericString = value.replaceAll(RegExp(r'[^0-9]'), '');
    // Parse to double (if possible)
    double amount = double.tryParse(numericString) ?? 0.0;
    // Format as currency
    return _currencyFormat.format(amount);
    }

  // Method to show OTP dialog
  Future<void> _showOtpDialog(Function() onOtpVerified) async {
    final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
    final List<FocusNode> _otpFocusNodes = List.generate(4, (index) => FocusNode());

    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
        return StatefulBuilder(
            builder: (context, setState) {
            return AlertDialog(
                title: Text('Xác thực OTP'),
                content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    Text('Vui lòng nhập mã OTP 4 chữ số được gửi đến số điện thoại của bạn.'),
                    SizedBox(height: 16),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(4, (index) {
                        return Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                        ),
                        child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _otpFocusNodes[index],
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
                                _otpFocusNodes[index + 1].requestFocus();
                            }
                            if (value.isEmpty && index > 0) {
                                _otpFocusNodes[index - 1].requestFocus();
                            }
                            if (value.isNotEmpty && index == 3) {
                                // Auto-submit when the last digit is entered
                                final otp = _otpControllers.map((controller) => controller.text).join();
                                if (otp.length == 4) {
                                _verifyOtp(otp, onOtpVerified, setState);
                                }
                            }
                            },
                        ),
                        );
                    }),
                    ),
                    if (_isVerifying)
                    Padding(
                        padding: EdgeInsets.only(top: 16),
                        child: CircularProgressIndicator(),
                    ),
                ],
                ),
                actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Hủy'),
                ),
                TextButton(
                    onPressed: () {
                    final otp = _otpControllers.map((controller) => controller.text).join();
                    if (otp.length != 4) {
                        ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Vui lòng nhập đủ 4 chữ số OTP')),
                        );
                        return;
                    }
                    _verifyOtp(otp, onOtpVerified, setState);
                    },
                    child: Text('Xác nhận'),
                ),
                ],
            );
            },
        );
        },
    );
    }

    void _verifyOtp(String otp, Function() onOtpVerified, void Function(void Function()) setState) async {
        setState(() => _isVerifying = true); // Show loading indicator
        try {
            // Simulate OTP verification (replace with actual API call)
            await Future.delayed(Duration(seconds: 2));

            // Call the callback (e.g., deposit/withdraw logic)
            await onOtpVerified(); // Await the callback

            // Close the dialog AFTER the callback completes
            Navigator.pop(context);
        } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Xác thực OTP thất bại: $e')),
            );
        } finally {
            setState(() => _isVerifying = false); // Hide loading indicator
        }
        }

  Future<void> _handleDeposit() async {
    print('Nộp tiền button clicked');
    if (_depositController.text.isEmpty) {
        print('Deposit amount is empty');
        return;
    }

    // Remove all non-numeric characters (e.g., commas, spaces, currency symbols)
    // Also replace thousand separators (e.g., periods) with an empty string
    final numericString = _depositController.text
        .replaceAll(RegExp(r'[^0-9]'), '') // Remove non-numeric characters
        .replaceAll('.', ''); // Remove thousand separators

    final amount = double.tryParse(numericString);

    if (amount == null) {
        print('Invalid deposit amount: ${_depositController.text}');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số tiền không hợp lệ')),
        );
        return;
    }

    print('Showing OTP dialog for amount: $amount');
    await _showOtpDialog(() async {
        print('OTP verified, processing deposit');
        setState(() => _isLoading = true);
        try {
        print('Calling deposit API');
        final response = await widget.powerService.deposit(widget.accountId, amount);
        print('Deposit API Response: $response');

        // Refresh the balance before returning
        await _loadBalance();

        _depositController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nộp tiền thành công')),
        );
        } catch (e) {
        print('Deposit failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Nộp tiền thất bại: $e')),
        );
        } finally {
        setState(() => _isLoading = false);
        }
    });
    }

  Future<void> _handleWithdraw() async {
    print('Rút tiền button clicked');
    if (_withdrawController.text.isEmpty) {
        print('Withdraw amount is empty');
        return;
    }

    // Remove all non-numeric characters (e.g., commas, spaces, currency symbols)
    // Also replace thousand separators (e.g., periods) with an empty string
    final numericString = _withdrawController.text
        .replaceAll(RegExp(r'[^0-9]'), '') // Remove non-numeric characters
        .replaceAll('.', ''); // Remove thousand separators

    final amount = double.tryParse(numericString);

    if (amount == null) {
        print('Invalid withdraw amount: ${_withdrawController.text}');
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Số tiền không hợp lệ')),
        );
        return;
    }

    print('Showing OTP dialog for amount: $amount');
    await _showOtpDialog(() async {
        print('OTP verified, processing withdraw');
        setState(() => _isLoading = true);
        try {
        print('Calling withdraw API');
        final response = await widget.powerService.withdraw(widget.accountId, amount);
        print('Withdraw API Response: $response');

        // Refresh the balance before returning
        await _loadBalance();

        _withdrawController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rút tiền thành công')),
        );
        } catch (e) {
        print('Withdraw failed: $e');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Rút tiền thất bại: $e')),
        );
        } finally {
        setState(() => _isLoading = false);
        }
    });
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: () async => _loadBalance(),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeaderCard(),
              _buildTransferSection(),
              _buildAutoTransferSection(),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  void showInfoModal() {
    showDialog(
        context: context,
        builder: (context) => InfoModal(
        onClose: () => Navigator.pop(context),
        ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: BackButton(),
      title: Text('iEarn - Tích luỹ thông minh'),
      actions: [
        IconButton(
          icon: Icon(Icons.history),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PowerHistoryScreen(
                accountId: widget.accountId,
                powerService: widget.powerService,
              ),
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.info_outline),
          onPressed: () => showInfoModal(),
        ),
      ],
    );
  }

  Widget _buildPowerSummarySection(PowerBalance balance) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Tăng số dư và giao dịch thêm để đạt 6.0%/năm'),
          TextButton(
            onPressed: () => showDetailsModal(),
            child: Text('Chi tiết'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard() {
    return FutureBuilder<PowerBalance>(
      future: _balanceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoadingCard();
        }
        if (snapshot.hasError) {
          return _buildErrorCard();
        }
        final balance = snapshot.data!;
        return Card(
          margin: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPowerSummarySection(balance),
              Divider(height: 24),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderInfo(balance),
                    _buildPowerSwitch(),
                    if (_isPowerEnabled) _buildPowerStatus(balance),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showDetailsModal() {
    showDialog(
      context: context,
      builder: (context) => DetailsModal(
        onClose: () => Navigator.pop(context),
      ),
    );
  }

  Widget _buildHeaderInfo(PowerBalance balance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Số dư', style: TextStyle(color: Colors.grey[600])),
                Text(
                  '${_currencyFormat.format(balance.balance)} ₫',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Tiền lãi', style: TextStyle(color: Colors.grey[600])),
                Text(
                  '${_currencyFormat.format(balance.interestBalance)} ₫',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPowerSwitch() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Tính iEarn vào sức mua cổ phiếu',
            style: TextStyle(fontSize: 15),
          ),
        ),
        Switch(
          value: _isPowerEnabled,
          activeColor: Colors.blue,
          onChanged: (value) {
            setState(() => _isPowerEnabled = value);
          },
        ),
      ],
    );
  }

  Widget _buildPowerStatus(PowerBalance balance) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Khả dụng', style: TextStyle(color: Colors.grey[600])),
            Text(
              '${_currencyFormat.format(balance.availableBalance)} ₫',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Phong tỏa', style: TextStyle(color: Colors.grey[600])),
            Text(
              '${_currencyFormat.format(balance.blockedBalance)} ₫',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransferSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nộp/Rút',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          _buildTransferField(
            controller: _depositController,
            selectedAccount: _selectedDepositAccount,
            onAccountChanged: (value) => setState(() => _selectedDepositAccount = value),
            label: 'Nộp từ TK',
            buttonText: 'NỘP TIỀN',
            onSubmit: _handleDeposit,
          ),
          SizedBox(height: 16),
          _buildTransferField(
            controller: _withdrawController,
            selectedAccount: _selectedWithdrawAccount,
            onAccountChanged: (value) => setState(() => _selectedWithdrawAccount = value),
            label: 'Rút sang TK',
            buttonText: 'RÚT TIỀN',
            onSubmit: _handleWithdraw,
          ),
        ],
      ),
    );
  }

  Widget _buildTransferField({
    required TextEditingController controller,
    required String selectedAccount,
    required Function(String) onAccountChanged,
    required String label,
    required String buttonText,
    required Function() onSubmit,
  }) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedAccount,
                    isExpanded: true,
                    items: ['Thường', 'Ký quỹ', 'Phái sinh']
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) onAccountChanged(value);
                    },
                  ),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: 'Số tiền',
                  border: OutlineInputBorder(),
                  suffixText: '₫',
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.isEmpty) {
                    controller.value = TextEditingValue.empty;
                    return;
                  }

                  // Remove all non-numeric characters
                  String numericString = value.replaceAll(RegExp(r'[^0-9]'), '');
                  
                  // Parse to double, defaulting to 0 if invalid
                  double amount = double.tryParse(numericString) ?? 0.0;
                  
                  // Format as currency
                  String formattedValue = _currencyFormat.format(amount);
                  
                  // Update the controller with the new value
                  controller.value = TextEditingValue(
                    text: formattedValue,
                    selection: TextSelection.collapsed(offset: formattedValue.length),
                  );
                },
                onSubmitted: (_) => onSubmit(),
              ),
            ],
          ),
        ),
        SizedBox(width: 16),
        ElevatedButton(
          onPressed: onSubmit,
          child: Text(buttonText),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAutoTransferSection() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nộp/Rút tự động',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (_isAutoTransferEnabled)
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => showAutoTransferSettingsModal(),
                ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            'Thiết lập iEarn tự động Nộp (vào 16h00) và/hoặc Rút (vào 08h00) hàng ngày.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tự động nộp/rút'),
              Switch(
                value: _isAutoTransferEnabled,
                activeColor: Colors.blue,
                onChanged: _handleAutoTransferSwitch,
              ),
            ],
          ),
          if (_isAutoTransferEnabled && _autoTransferSettings != null) ...[
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tùy chọn:'),
                Text(_autoTransferSettings!['transfer_option'] ?? 'Nộp'),
              ],
            ),
            ..._buildMinBalanceInfo(),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildMinBalanceInfo() {
    final balances = _autoTransferSettings?['balances'] as Map<String, dynamic>?;
    if (balances == null) return [];

    return [
      SizedBox(height: 16),
      Text(
        'Số dư tối thiểu:',
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
      SizedBox(height: 8),
      ...balances.entries.map((entry) => Padding(
        padding: EdgeInsets.only(left: 16, bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(entry.key),
            Text('${_currencyFormat.format(entry.value)} ₫'),
          ],
        ),
      )).toList(),
    ];
  }

  void showAutoTransferSettingsModal() {
    showDialog(
      context: context,
      builder: (context) => AutoTransferSettingsModal(
        onClose: () {
          Navigator.pop(context);
          _loadAutoTransferSettings(); // Reload settings after modal closes
        },
        accountId: widget.accountId,
        powerService: widget.powerService,
      ),
    );
  }

  Widget _buildAutoTransferSettings() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        Divider(height: 24),
        _buildAccountMinBalanceSection(),
        SizedBox(height: 16),
        _buildAutoTransferOptions(),
        ],
    );
  }

  Widget _buildAutoTransferOptions() {
    String selectedOption = 'Nộp'; // Default selected option

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tùy chọn tự động nộp/rút',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(4),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selectedOption,
              isExpanded: true,
              items: ['Nộp', 'Rút', 'Nộp & Rút']
                  .map((option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    selectedOption = value;
                  });
                }
              },
            ),
          ),
        ),
        SizedBox(height: 16),
        _buildAccountMinBalanceSection(), // Call the method here
      ],
    );
  }

  // Define the missing method
  Widget _buildAccountMinBalanceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tài khoản duy trì số dư tối thiểu',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 8),
        _buildAccountMinBalance('TK Thường', 1000000),
        _buildAccountMinBalance('TK Ký quỹ', 1000000),
        _buildAccountMinBalance('TK Phái sinh', 0),
      ],
    );
  }

  // Helper method to build account minimum balance rows
  Widget _buildAccountMinBalance(String account, double amount) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: true,
            onChanged: null,
          ),
          Text(account),
          Spacer(),
          Text('${_currencyFormat.format(amount)} ₫'),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Container(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(
              'Không thể tải thông tin tài khoản',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            TextButton(
              onPressed: _loadBalance,
              child: Text('Thử lại'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _balanceTimer?.cancel();
    _depositController.dispose();
    _withdrawController.dispose();
    super.dispose();
  }
}