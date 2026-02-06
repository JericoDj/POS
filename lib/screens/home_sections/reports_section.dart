import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_dimensions.dart';

class ReportsSection extends StatelessWidget {
  const ReportsSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Determine grid columns based on screen width
    int crossAxisCount = AppDimensions.screenWidth < 900
        ? 1
        : AppDimensions.screenWidth < 1200
        ? 2
        : 4;

    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(AppDimensions.paddingL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildKPIGrid(crossAxisCount),
                  const SizedBox(height: 24),
                  _buildSalesChartSection(),
                  const SizedBox(height: 24),
                  if (AppDimensions.screenWidth < 1000) ...[
                    _buildTopProductsSection(),
                    const SizedBox(height: 24),
                    _buildPaymentMethodsSection(),
                  ] else
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 2, child: _buildTopProductsSection()),
                        const SizedBox(width: 24),
                        Expanded(flex: 1, child: _buildPaymentMethodsSection()),
                      ],
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 64,
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.8),
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Business Reports',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppConstants.slate800,
            ),
          ),
          Row(
            children: [
              // Date Picker Simulation
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppConstants.backgroundLight,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Row(
                  children: [
                    _buildDateOption('Today', false),
                    _buildDateOption('Last 7 Days', true),
                    _buildDateOption('Custom', false),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Export Button
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download, size: 18),
                label: const Text('Export'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDateOption(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(6),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 2,
                ),
              ]
            : null,
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: isSelected ? AppConstants.primaryColor : AppConstants.slate500,
        ),
      ),
    );
  }

  Widget _buildKPIGrid(int crossAxisCount) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double width =
            (constraints.maxWidth - (crossAxisCount - 1) * 16) / crossAxisCount;
        // fallback if width calculation fails or is weird
        if (width < 150) width = constraints.maxWidth;

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _buildKPICard(
              'Total Revenue',
              '\$12,340.00',
              Icons.payments,
              12,
              true,
              width,
            ),
            _buildKPICard(
              'Net Profit',
              '\$4,200.50',
              Icons.show_chart,
              5,
              true,
              width,
              isPro: true,
            ),
            _buildKPICard(
              'Total Orders',
              '342',
              Icons.shopping_bag,
              2,
              false,
              width,
            ),
            _buildKPICard(
              'Avg Order Value',
              '\$36.08',
              Icons.receipt_long,
              8,
              true,
              width,
            ),
          ],
        );
      },
    );
  }

  Widget _buildKPICard(
    String label,
    String value,
    IconData icon,
    double percentage,
    bool isPositive,
    double width, {
    bool isPro = false,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppConstants.slate500,
                    ),
                  ),
                  if (isPro) ...[
                    const SizedBox(width: 6),
                    const Icon(Icons.lock, size: 14, color: Colors.amber),
                  ],
                ],
              ),
              Icon(icon, color: AppConstants.slate500, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppConstants.slate800,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPositive
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Icon(
                      isPositive ? Icons.trending_up : Icons.trending_down,
                      size: 14,
                      color: isPositive ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isPositive ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'vs last period',
                style: TextStyle(fontSize: 12, color: AppConstants.slate500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalesChartSection() {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Sales Performance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.slate800,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Revenue trends across the selected period',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppConstants.slate500,
                    ),
                  ),
                ],
              ),
              // Legend
              Row(
                children: [
                  _buildLegendItem('Revenue', AppConstants.primaryColor),
                  const SizedBox(width: 12),
                  _buildLegendItem('Previous', Colors.grey),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(color: Colors.grey[100], strokeWidth: 1);
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(
                          color: AppConstants.slate500,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        );
                        String text;
                        switch (value.toInt()) {
                          case 0:
                            text = 'Oct 24';
                            break;
                          case 1:
                            text = 'Oct 25';
                            break;
                          case 2:
                            text = 'Oct 26';
                            break;
                          case 3:
                            text = 'Oct 27';
                            break;
                          case 4:
                            text = 'Oct 28';
                            break;
                          case 5:
                            text = 'Oct 29';
                            break;
                          case 6:
                            text = 'Oct 30';
                            break;
                          default:
                            return Container();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          space: 10,
                          child: Text(text, style: style),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1000,
                      reservedSize: 42,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '\$${value ~/ 1000}k',
                          style: const TextStyle(
                            color: AppConstants.slate500,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.right,
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: 6,
                minY: 0,
                maxY: 4000,
                lineBarsData: [
                  // Previous Period (Dashed)
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 2000),
                      FlSpot(1, 1800),
                      FlSpot(2, 2200),
                      FlSpot(3, 1900),
                      FlSpot(4, 2400),
                      FlSpot(5, 2100),
                      FlSpot(6, 2500),
                    ],
                    isCurved: true,
                    color: Colors.grey[400],
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                    dashArray: [5, 5],
                  ),
                  // Current Revenue
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1500),
                      FlSpot(1, 1800),
                      FlSpot(2, 3200),
                      FlSpot(3, 2800),
                      FlSpot(4, 4200), // Peak
                      FlSpot(5, 3100),
                      FlSpot(6, 3800),
                    ],
                    isCurved: true,
                    color: AppConstants.primaryColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      checkToShowDot: (spot, barData) {
                        return spot.x == 4; // Show dot at peak
                      },
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: AppConstants.primaryColor,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppConstants.primaryColor.withValues(alpha: 0.2),
                          AppConstants.primaryColor.withValues(alpha: 0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: AppConstants.slate500,
          ),
        ),
      ],
    );
  }

  Widget _buildTopProductsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Top Selling Products',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.slate800,
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
          const SizedBox(height: 16),
          // Header Row
          Row(
            children: const [
              Expanded(
                flex: 3,
                child: Text('Product Name', style: _headerStyle),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Price',
                  textAlign: TextAlign.right,
                  style: _headerStyle,
                ),
              ),
              Expanded(
                flex: 1,
                child: Text(
                  'Sold',
                  textAlign: TextAlign.right,
                  style: _headerStyle,
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Volume',
                  textAlign: TextAlign.right,
                  style: _headerStyle,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildProductRow('Blueberry Muffin', 'Pastry', '\$4.50', '124', 0.85),
          const Divider(height: 24),
          _buildProductRow('Caramel Latte', 'Beverage', '\$5.25', '98', 0.65),
          const Divider(height: 24),
          _buildProductRow('Butter Croissant', 'Pastry', '\$3.75', '85', 0.50),
        ],
      ),
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: AppConstants.slate500,
    letterSpacing: 0.5,
  );

  Widget _buildProductRow(
    String name,
    String category,
    String price,
    String sold,
    double progress,
  ) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.fastfood,
                  color: Colors.grey,
                ), // Placeholder
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    category,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppConstants.slate500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            price,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 1,
          child: Text(
            sold,
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[100],
                color: AppConstants.primaryColor,
                minHeight: 8,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.slate800,
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 0,
                    centerSpaceRadius: 70,
                    sections: [
                      PieChartSectionData(
                        color: AppConstants.primaryColor,
                        value: 60,
                        title: '',
                        radius: 20,
                      ),
                      PieChartSectionData(
                        color: const Color(0xFF078843), // Success Green
                        value: 30,
                        title: '',
                        radius: 20,
                      ),
                      PieChartSectionData(
                        color: Colors.amber,
                        value: 10,
                        title: '',
                        radius: 20,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      '342', // Total
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.slate800,
                      ),
                    ),
                    Text(
                      'Total Txns',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppConstants.slate500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildPaymentLegend('Credit Card', '60%', AppConstants.primaryColor),
          const SizedBox(height: 12),
          _buildPaymentLegend('Cash', '30%', const Color(0xFF078843)),
          const SizedBox(height: 12),
          _buildPaymentLegend('QR / Mobile', '10%', Colors.amber),
        ],
      ),
    );
  }

  Widget _buildPaymentLegend(String label, String percent, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(shape: BoxShape.circle, color: color),
            ),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        ),
        Text(percent, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
