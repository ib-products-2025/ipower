import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/power_service.dart';

const String TK_THUONG = "TK Thường";
const String TK_KY_QUY = "TK Ký quỹ";
const String TK_PHAI_SINH = "TK Phái sinh";

class AutoTransferSettingsModal extends StatefulWidget {
  final VoidCallback onClose;
  final String accountId;
  final PowerService powerService;

  const AutoTransferSettingsModal({
    Key? key, 
    required this.onClose,
    required this.accountId,
    required this.powerService,
  }) : super(key: key);

  @override
  _AutoTransferSettingsModalState createState() => _AutoTransferSettingsModalState();
}

class _AutoTransferSettingsModalState extends State<AutoTransferSettingsModal> {
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '', decimalDigits: 0);
  late Map<String, double> _balances;
  late Map<String, TextEditingController> _controllers;
  bool _isLoading = true;
  String _selectedTransferOption = 'Nộp';
  
  @override
  void initState() {
    super.initState();
    _balances = {
      'TK Thường': 1000000,
      'TK Ký quỹ': 1000000,
      'TK Phái sinh': 0,
    };
    _controllers = {};
    _loadSavedSettings();
  }

  Future<void> _loadSavedSettings() async {
    try {
      setState(() => _isLoading = true);
      final settings = await widget.powerService.getAutoTransferSettings(widget.accountId);
      
      setState(() {
        // Get balances from settings
        if (settings['balances'] != null) {
          _balances = Map<String, double>.from(settings['balances']);
        }
        
        // Initialize controllers with saved values
        _controllers = _balances.map((key, value) => MapEntry(
          key,
          TextEditingController(text: _currencyFormat.format(value))
        ));
        
        // Get transfer option
        _selectedTransferOption = settings['transfer_option'] ?? 'Nộp';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải cấu hình: $e')),
      );
      // Initialize controllers with default values if load fails
      _controllers = _balances.map((key, value) => MapEntry(
        key,
        TextEditingController(text: _currencyFormat.format(value))
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  String _formatCurrency(String value) {
    if (value.isEmpty) return '';
    String numericString = value.replaceAll(RegExp(r'[^0-9]'), '');
    double amount = double.tryParse(numericString) ?? 0.0;
    return _currencyFormat.format(amount);
  }

  Future<void> _saveSettings() async {
    try {
      setState(() => _isLoading = true);
      
      // Create complete settings object
      final settings = {
        'balances': _balances,
        'transfer_option': _selectedTransferOption,
        'enabled': true,
      };
      
      await widget.powerService.setAutoTransferSettings(widget.accountId, settings);
      widget.onClose();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Đã lưu cấu hình thành công')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể lưu cấu hình: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Đang tải...'),
            ],
          ),
        ),
      );
    }

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tuỳ chọn tự động nộp/rút',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(4),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedTransferOption,
                  isExpanded: true,
                  items: ['Nộp', 'Rút', 'Nộp & Rút']
                      .map((option) => DropdownMenuItem(
                            value: option,
                            child: Text(option),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedTransferOption = value);
                    }
                  },
                ),
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Tài khoản duy trì số dư tối thiểu',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ..._balances.keys.map((account) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(child: Text(account)),
                  SizedBox(width: 16),
                  Expanded(
                    child: TextField(
                      controller: _controllers[account],
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        suffixText: '₫',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      onChanged: (value) {
                        final formattedValue = _formatCurrency(value);
                        _controllers[account]?.value = TextEditingValue(
                          text: formattedValue,
                          selection: TextSelection.collapsed(offset: formattedValue.length),
                        );
                        final numericString = formattedValue.replaceAll(RegExp(r'[^0-9]'), '');
                        _balances[account] = double.tryParse(numericString) ?? 0.0;
                      },
                    ),
                  ),
                ],
              ),
            )).toList(),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: widget.onClose,
                  child: Text('Hủy'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _saveSettings,
                  child: Text('Lưu'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}