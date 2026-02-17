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
            ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 2)]
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
          children: [_buildEmptyState('No financial data available')],
        );
      },
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.bar_chart_outlined, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              fontSize: 16,
              color: AppConstants.slate500,
              fontWeight: FontWeight.w500,
            ),
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
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, size: 64, color: Colors.grey[300]),
                  const SizedBox(height: 16),
                  const Text(
                    'No sales data for this period',
                    style: TextStyle(color: AppConstants.slate500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Selling Products',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.slate800,
            ),
          ),
          const SizedBox(height: 16),
          _buildEmptyState('No product data available'),
        ],
      ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Methods',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.slate800,
            ),
          ),
          const SizedBox(height: 16),
          _buildEmptyState('No payment data available'),
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
}
