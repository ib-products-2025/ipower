import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/power_service.dart';
import '../models/power_models.dart';

class PowerHistoryScreen extends StatefulWidget {
  final String accountId;
  final PowerService powerService;

  const PowerHistoryScreen({
    Key? key,
    required this.accountId,
    required this.powerService,
  }) : super(key: key);

  @override
  _PowerHistoryScreenState createState() => _PowerHistoryScreenState();
}

class _PowerHistoryScreenState extends State<PowerHistoryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late DateTime _startDate;
  late DateTime _endDate;
  String _status = 'Tất cả';
  bool _isLoading = false;
  PowerHistory? _historyData;
  final _currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _startDate = DateTime.now().subtract(Duration(days: 30));
    _endDate = DateTime.now();
    _loadHistory();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final history = await widget.powerService.getHistory(
        widget.accountId,
        _startDate,
        _endDate,
        _status == 'Tất cả' ? null : _status,
      );
      setState(() => _historyData = history);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Không thể tải lịch sử: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Lịch sử'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Giao dịch'),
            Tab(text: 'Tiền lãi'),
          ],
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
        ),
      ),
      body: Column(
        children: [
          _buildFilterSection(),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _buildTransactionList(),
                      _buildInterestList(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection() {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDateField('Từ ngày', _startDate)),
              SizedBox(width: 8),
              Expanded(child: _buildDateField('Đến ngày', _endDate)),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _status,
                      isExpanded: true,
                      items: ['Tất cả', 'Thành công', 'Đang xử lý', 'Thất bại']
                          .map((status) => DropdownMenuItem(
                                value: status,
                                child: Text(status),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _status = value);
                        }
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8),
              ElevatedButton(
                onPressed: _loadHistory,
                child: Text('TRA CỨU'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(String label, DateTime date) {
    return InkWell(
      onTap: () async {
        final newDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
        );
        if (newDate != null) {
          setState(() {
            if (label.startsWith('Từ')) {
              _startDate = newDate;
            } else {
              _endDate = newDate;
            }
          });
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy').format(date),
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionList() {
    final transactions = _historyData?.transactions ?? [];
    
    if (transactions.isEmpty) {
      return _buildEmptyState('Không tìm thấy giao dịch nào');
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        final isDeposit = transaction.type == 'deposit';
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: isDeposit ? Colors.green[100] : Colors.red[100],
              child: Icon(
                isDeposit ? Icons.arrow_upward : Icons.arrow_downward,
                color: isDeposit ? Colors.green : Colors.red,
              ),
            ),
            title: Text(
              _currencyFormat.format(transaction.amount),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDeposit ? Colors.green : Colors.red,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('HH:mm dd/MM/yyyy').format(transaction.timestamp),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  transaction.status,
                  style: TextStyle(
                    color: _getStatusColor(transaction.status),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            trailing: Text(
              isDeposit ? 'Nộp tiền' : 'Rút tiền',
              style: TextStyle(
                color: isDeposit ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInterestList() {
    final interests = _historyData?.interestRecords ?? [];
    
    if (interests.isEmpty) {
      return _buildEmptyState('Không tìm thấy lãi nào');
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 8),
      itemCount: interests.length,
      itemBuilder: (context, index) {
        final interest = interests[index];
        
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.percent, color: Colors.blue),
            ),
            title: Text(
              _currencyFormat.format(interest.amount),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('HH:mm dd/MM/yyyy').format(interest.timestamp),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                Text(
                  'Lãi suất: ${(interest.rate * 100).toStringAsFixed(2)}%/năm',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'thành công':
        return Colors.green;
      case 'đang xử lý':
        return Colors.orange;
      case 'thất bại':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}