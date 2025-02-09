import 'package:flutter/material.dart';

class InfoModal extends StatefulWidget {
  final VoidCallback onClose;

  const InfoModal({Key? key, required this.onClose}) : super(key: key);

  @override
  State<InfoModal> createState() => _InfoModalState();
}

class _InfoModalState extends State<InfoModal> {
  int _selectedExample = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'iEarn - Tích luỹ thông minh',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: 'iEarn là Tích luỹ thông minh tự động, giúp tối ưu lợi ích từ số dư tiền trong tài khoản.\n\n'
                  ),
                  TextSpan(
                    text: 'Đặc biệt, cơ chế lãi suất linh hoạt theo số dư và giá trị giao dịch giúp bạn có thể chủ động gia tăng lãi suất cho tài khoản của mình lên đến ',
                  ),
                  TextSpan(
                    text: '6.0%/năm',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(text: '.'),
                ],
              ),
            ),
            _buildFeatureSection(),
            _buildInterestRateSection(),
            _buildCalculationExamples(),
            _buildFAQSection(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onClose,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Đóng'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Thông tin được cung cấp bởi iEarn',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Ưu điểm vượt trội của iEarn',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildFeature(
          icon: Icons.autorenew,
          title: 'Tự động',
          description: 'Sinh lãi tự động và cập nhật hàng ngày',
        ),
        const SizedBox(height: 12),
        _buildFeature(
          icon: Icons.access_time,
          title: 'Tiện lợi',
          description: 'Nộp - rút 24/7, tự động quét tiền định kỳ và được tính vào sức mua cổ phiếu',
        ),
        const SizedBox(height: 12),
        _buildFeature(
          icon: Icons.trending_up,
          title: 'Linh hoạt',
          description: 'Lãi suất linh hoạt theo số dư và giá trị giao dịch, lên đến 6.0%/năm',
        ),
      ],
    );
  }

  Widget _buildFeature({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.red, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey[600],
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

  Widget _buildInterestRateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          'Cách tăng lãi suất cho tài khoản iEarn',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildInterestRateFormula(),
        const SizedBox(height: 24),
        _buildBalanceBasedRate(),
        const SizedBox(height: 24),
        _buildTradingVolumeRate(),
        const SizedBox(height: 24),
        _buildCombinedRateTable(),
      ],
    );
  }

  Widget _buildInterestRateFormula() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lãi suất iEarn được xác định như sau:',
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFormulaItem(
              icon: Icons.account_balance,
              label: '6.0%',
              subLabel: 'Lãi suất\niEarn',
              isResult: true,
            ),
            Text('=', style: TextStyle(color: Colors.black, fontSize: 24)),
            _buildFormulaItem(
              icon: Icons.shopping_cart,
              label: '2.5%',
              subLabel: 'Lãi suất\ncơ bản',
            ),
            Text('+', style: TextStyle(color: Colors.black, fontSize: 24)),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  _buildFormulaItem(
                    icon: Icons.account_balance_wallet,
                    label: '1.5%',
                    subLabel: 'Lãi căn cứ trên\nsố dư',
                  ),
                  Text('+', style: TextStyle(color: Colors.black, fontSize: 24)),
                  _buildFormulaItem(
                    icon: Icons.sync_alt,
                    label: '2.0%',
                    subLabel: 'Lãi căn cứ trên\nGTGD lũy kế tháng',
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormulaItem({
    required IconData icon,
    required String label,
    required String subLabel,
    bool isResult = false,
  }) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isResult ? Colors.red : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subLabel,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildBalanceBasedRate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lãi căn cứ trên số dư',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey[300]!),
          children: [
            _buildTableHeader(['Số dư tiền (VND)', 'Lãi (%/năm)']),
            _buildTableRow(['Từ 5tr đến < 500tr', '0.3%']),
            _buildTableRow(['Từ 500tr đến < 2 tỷ', '0.5%']),
            _buildTableRow(['Từ 2 tỷ đến < 5 tỷ', '0.7%']),
            _buildTableRow(['Từ 5 tỷ đến < 10 tỷ', '1.0%']),
            _buildTableRow(['Từ 10 tỷ trở lên', '1.5%']),
          ],
        ),
      ],
    );
  }

  Widget _buildTradingVolumeRate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Lãi căn cứ trên GTGD lũy kế tháng',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 12),
        Table(
          border: TableBorder.all(color: Colors.grey[300]!),
          children: [
            _buildTableHeader(['GTGD lũy kế tháng (VND)', 'Lãi (%/năm)']),
            _buildTableRow(['Nhỏ hơn 500tr', '0.5%']),
            _buildTableRow(['Từ 500tr đến < 2 tỷ', '0.7%']),
            _buildTableRow(['Từ 2 tỷ đến < 5 tỷ', '1.0%']),
            _buildTableRow(['Từ 5 tỷ đến < 10 tỷ', '1.5%']),
            _buildTableRow(['Từ 10 tỷ trở lên', '2.0%']),
          ],
        ),
      ],
    );
  }

  TableRow _buildTableHeader(List<String> cells) {
    return TableRow(
      decoration: BoxDecoration(color: Colors.grey[100]),
      children: cells.map((cell) => TableCell(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            cell,
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      )).toList(),
    );
  }

  TableRow _buildTableRow(List<String> cells) {
    return TableRow(
      children: cells.map((cell) => TableCell(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            cell,
            style: TextStyle(color: Colors.black),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildCombinedRateTable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bảng tổng hợp lãi suất',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Table(
            defaultColumnWidth: FixedColumnWidth(120),
            border: TableBorder.all(color: Colors.grey[800]!),
            children: [
              // Header row
              TableRow(
                children: [
                  _buildTableCell('SỐ DƯ', header: true, isFirstColumn: true),
                  _buildTableCell('GTGD LŨY KẾ THÁNG', header: true),
                  _buildTableCell('', header: true),
                  _buildTableCell('', header: true),
                  _buildTableCell('', header: true),
                  _buildTableCell('', header: true),
                ],
              ),
              // Sub-header row
              TableRow(
                children: [
                  _buildTableCell('', isFirstColumn: true),
                  _buildTableCell('Nhỏ hơn\n500tr', header: true),
                  _buildTableCell('Từ 500tr đến\n< 2 tỷ', header: true),
                  _buildTableCell('Từ 2 tỷ đến\n< 5 tỷ', header: true),
                  _buildTableCell('Từ 5 tỷ đến\n< 10 tỷ', header: true),
                  _buildTableCell('Từ 10 tỷ\ntrở lên', header: true),
                ],
              ),
              // Data rows
              _buildCombinedRateRow('Từ 5tr đến\n< 500tr', ['3.3%', '3.5%', '3.8%', '4.3%', '4.8%']),
              _buildCombinedRateRow('Từ 500tr đến\n< 2 tỷ', ['3.5%', '3.7%', '4.0%', '4.5%', '5.0%']),
              _buildCombinedRateRow('Từ 2 tỷ đến\n< 5 tỷ', ['3.7%', '3.9%', '4.2%', '4.7%', '5.2%']),
              _buildCombinedRateRow('Từ 5 tỷ đến\n< 10 tỷ', ['4.0%', '4.2%', '4.5%', '5.0%', '5.5%']),
              _buildCombinedRateRow('Từ 10 tỷ\ntrở lên', ['4.5%', '4.7%', '5.0%', '5.5%', '6.0%']),
            ],
          ),
        ),
        _buildNotes(),
      ],
    );
  }

  TableRow _buildCombinedRateRow(String label, List<String> values) {
    return TableRow(
      children: [
        _buildTableCell(label, isFirstColumn: true),
        ...values.map((value) => _buildTableCell(
          value,
          highlight: value == '6.0%',
        )),
      ],
    );
  }

  Widget _buildTableCell(String text, {
    bool header = false,
    bool isFirstColumn = false,
    bool highlight = false,
  }) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: header ? Colors.grey[100] : null,
        ),
        child: Text(
          text,
          style: TextStyle(
            color: highlight ? Colors.red : Colors.black,
            fontWeight: header || isFirstColumn ? FontWeight.bold : null,
            fontSize: 12,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  List<TableRow> _buildCombinedRateRows() {
    final rows = [
      ['Từ 5tr đến\n< 500tr', '3.3%', '3.5%', '3.8%', '4.3%', '4.8%'],
      ['Từ 500tr đến\n< 2 tỷ', '3.5%', '3.7%', '4.0%', '4.5%', '5.0%'],
      ['Từ 2 tỷ đến\n< 5 tỷ', '3.7%', '3.9%', '4.2%', '4.7%', '5.2%'],
      ['Từ 5 tỷ đến\n< 10 tỷ', '4.0%', '4.2%', '4.5%', '5.0%', '5.5%'],
      ['Từ 10 tỷ\ntrở lên', '4.5%', '4.7%', '5.0%', '5.5%', '6.0%'],
    ];

    return rows.map((row) {
      return TableRow(
        children: [
          _buildTableCell(row[0], isFirstColumn: true),
          ...row.skip(1).map((cell) => _buildTableCell(cell, highlight: cell == '6.0%')).toList(),
        ],
      );
    }).toList();
  }

  Widget _buildNotes() {
    return Container(
      margin: EdgeInsets.only(top: 16),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trong đó:',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '• Số dư iEarn là số dư nhỏ nhất trong khoảng thời gian từ 18h ngày hiện tại đến 0h ngày hôm sau.\n\n'
            '• Giá trị giao dịch lũy kế tháng là giá trị các giao dịch thành công từ ngày đầu tháng hiện tại đến ngày tính lãi, bao gồm các giao dịch mua/bán cổ phiếu, trái phiếu, chứng chỉ quỹ mở và giao dịch giải ngân vay ký quỹ.\n\n'
            '• Lãi suất iEarn chỉ áp dụng khi số dư iEarn đạt tối thiểu 5 triệu đồng và tối đa 60 tỷ đồng.',
            style: TextStyle(
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalculationExamples() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Ví dụ minh họa',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildExampleTab(0, '6.0%'),
            const SizedBox(width: 8),
            _buildExampleTab(1, '3.7%'),
            const SizedBox(width: 8),
            _buildExampleTab(2, '0%'),
          ],
        ),
        const SizedBox(height: 16),
        _buildSelectedExample(),
      ],
    );
  }

  Widget _buildExampleTab(int index, String rate) {
    bool isSelected = _selectedExample == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedExample = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? Colors.red : Colors.grey[300]!,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(8),
            color: isSelected ? Colors.red.withOpacity(0.1) : null,
          ),
          child: Column(
            children: [
              Text(
                'Ví dụ ${index + 1}',
                style: TextStyle(
                  color: isSelected ? Colors.red : Colors.grey[600],
                ),
              ),
              Text(
                'Lãi suất $rate',
                style: TextStyle(
                  color: isSelected ? Colors.red : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedExample() {
    switch (_selectedExample) {
      case 0:
        return _buildExample(
          text: 'Anh Linh đăng ký iEarn - Tích luỹ thông minh ngày 06/01/2025. Tổng giá trị giao dịch cổ phiếu lũy kế của anh Linh từ 01/01/2025 đến 06/01/2025 là 10 tỷ đồng. Cuối ngày 06/01/2025, số dư iEarn của anh Linh là 12 tỷ đồng.',
          rateFormula: _buildRateFormula('6.0%', '2.5%', '1.5%', '2.0%'),
        );
      case 1:
        return _buildExample(
          text: 'Ngày 01/04/2025, chị Hải đăng ký iEarn - Tích luỹ thông minh và mua 500 triệu đồng trái phiếu. Cuối ngày 01/04/2025, số dư iEarn của chị Hải là 1 tỷ đồng.',
          rateFormula: _buildRateFormula('3.7%', '2.5%', '0.5%', '0.7%'),
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Anh Trường đăng ký iEarn - Tích luỹ thông minh ngày 09/04/2025 và có giá trị giao dịch lũy kế từ 01/04/2025 đến 09/04/2025 là 2 tỷ đồng, số dư iEarn cuối ngày 09/04/2025 là 3 triệu đồng.',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Anh Trường không được nhận lãi suất cho số tiền 3 triệu đồng này do anh Trường có số dư iEarn < 5 triệu',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      default:
        return SizedBox.shrink();
    }
  }

  Widget _buildExample({
    required String text,
    required Widget rateFormula,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 16),
        Text(
          'Lãi suất nhận được:',
          style: TextStyle(color: Colors.black),
        ),
        const SizedBox(height: 16),
        rateFormula,
      ],
    );
  }

  Widget _buildRateFormula(String totalRate, String baseRate, String balanceRate, String tradingRate) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFormulaItem(
          icon: Icons.account_balance,
          label: totalRate,
          subLabel: 'Lãi suất\niEarn',
          isResult: true,
        ),
        Text('=', style: TextStyle(color: Colors.black, fontSize: 24)),
        _buildFormulaItem(
          icon: Icons.shopping_cart,
          label: baseRate,
          subLabel: 'Lãi suất\ncơ bản',
        ),
        Text('+', style: TextStyle(color: Colors.black, fontSize: 24)),
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!, width: 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              _buildFormulaItem(
                icon: Icons.account_balance_wallet,
                label: balanceRate,
                subLabel: 'Lãi căn cứ trên\nsố dư',
              ),
              Text('+', style: TextStyle(color: Colors.black, fontSize: 24)),
              _buildFormulaItem(
                icon: Icons.sync_alt,
                label: tradingRate,
                subLabel: 'Lãi căn cứ trên\nGTGD lũy kế tháng',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'Các câu hỏi thường gặp',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 16),
        _buildFAQItem(
          'Số dư iEarn được tính lãi suất hàng ngày như thế nào?',
          'Lãi suất áp dụng cho số dư iEarn nhỏ nhất (tối thiểu 5 triệu VND, tối đa 60 tỷ VND) trong khoảng thời gian từ 18h ngày hiện tại đến 0h ngày hôm sau.',
        ),
        _buildFAQItem(
          'Giá trị giao dịch để xét lãi suất là giá trị trước hay sau phí, thuế?',
          'Giá trị giao dịch xét lãi suất là giá trị giao dịch trước khi tính thuế và phí.',
        ),
        _buildFAQItem(
          'Lãi suất có phải là cố định không?',
          'Lãi suất được tính toán hàng ngày, có thể thay đổi dựa trên các điều kiện về số dư iEarn cuối ngày và giao dịch trên tài khoản TCBS.',
        ),
        _buildFAQItem(
          'Tiền lãi từ iEarn được thanh toán như thế nào?',
          'Tiền lãi trong tháng được thanh toán về tiểu khoản Thường trên tài khoản chứng khoán trong vòng 05 ngày làm việc của tháng tiếp theo.',
        ),
        _buildFAQItem(
          'Hạn mức chuyển tiền vào iEarn là bao nhiêu?',
          'Hạn mức tối thiểu: 50.000 VND trên một giao dịch. Hạn mức tối đa: không giới hạn.',
        ),
        _buildFAQItem(
          'Hạn mức rút tiền tối đa từ iEarn ra tài khoản ngân hàng?',
          'Có thể rút tiền khả dụng từ iEarn theo hạn mức chuyển tiền tối đa được cài đặt trên tài khoản chứng khoán.',
        ),
        _buildFAQItem(
          'Có thể rút tiền từ iEarn ra tài khoản ngân hàng 24/7 không?',
          'Có. Tuy nhiên lệnh chuyển tiền liên ngân hàng chỉ được xử lý 24/7 nếu giá trị rút dưới 500 triệu VND.',
        ),
        _buildFAQItem(
          'Tiện ích "Tính iEarn vào sức mua cổ phiếu" hoạt động như thế nào?',
          'Khi bật tiện ích này, tiền khả dụng trên iEarn sẽ:\n- Được sử dụng để tính vào sức mua cổ phiếu và tự động phong tỏa, cắt tiền để thanh toán cho giao dịch mua.\n- Được sử dụng để trả nợ vay ký quỹ hoặc các nghĩa vụ nợ khác (nếu có).',
          hasLink: true,
          linkText: 'Xem thêm tại Liên kết nguồn tiền',
        ),
      ],
    );
  }

  Widget _buildFAQItem(String question, String answer, {bool hasLink = false, String? linkText}) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          question,
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        iconColor: Colors.black,
        collapsedIconColor: Colors.black,
        tilePadding: EdgeInsets.symmetric(vertical: 8),
        children: [
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  answer,
                  style: TextStyle(
                    color: Colors.grey[600],
                    height: 1.5,
                  ),
                ),
                if (hasLink && linkText != null) ...[
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      // Handle link tap
                    },
                    child: Text(
                      linkText,
                      style: TextStyle(
                        color: Colors.red,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}