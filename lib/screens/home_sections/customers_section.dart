import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class CustomersSection extends StatefulWidget {
  const CustomersSection({super.key});

  @override
  State<CustomersSection> createState() => _CustomersSectionState();
}

class _CustomersSectionState extends State<CustomersSection> {
  int _selectedCustomerId = 1;

  // Mock Data
  final List<Map<String, dynamic>> _customers = [
    {
      'id': 1,
      'name': 'Jane Cooper',
      'email': 'jane.cooper@example.com',
      'phone': '+1 (555) 012-3456',
      'points': 1250,
      'image': 'https://i.pravatar.cc/150?u=1',
      'isGold': true,
    },
    {
      'id': 2,
      'name': 'Guy Hawkins',
      'email': 'guy.hawkins@example.com',
      'phone': '+1 (555) 987-6543',
      'points': 850,
      'image': 'https://i.pravatar.cc/150?u=2',
      'isGold': false,
    },
    {
      'id': 3,
      'name': 'Kristin Watson',
      'email': 'kristin.w@example.com',
      'phone': '+1 (555) 234-5678',
      'points': 420,
      'image': 'https://i.pravatar.cc/150?u=3',
      'isGold': false,
    },
    {
      'id': 4,
      'name': 'Cody Fisher',
      'email': 'cody.fisher@example.com',
      'phone': '+1 (555) 345-6789',
      'points': 0,
      'initials': 'CW',
      'isGold': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    // Left pane width: 25% of screen width, min 300, max 450
    final leftPaneWidth = (width * 0.25).clamp(300.0, 450.0);

    return Row(
      children: [
        // Left Pane: Customer List
        Container(
          width: leftPaneWidth,
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(
              right: BorderSide(color: Color(0xFFE2E8F0)), // gray-200
            ),
          ),
          child: Column(
            children: [
              _buildListHeader(width),
              Expanded(
                child: ListView.builder(
                  itemCount: _customers.length,
                  itemBuilder: (context, index) {
                    final customer = _customers[index];
                    return _buildCustomerListItem(customer, width);
                  },
                ),
              ),
            ],
          ),
        ),

        // Right Pane: Details
        Expanded(
          child: Container(
            color: AppConstants.backgroundLight,
            child: _buildCustomerDetails(width),
          ),
        ),
      ],
    );
  }

  Widget _buildListHeader(double width) {
    return Container(
      padding: EdgeInsets.all(width * 0.01), // ~16px
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Customers',
                style: TextStyle(
                  fontSize: width * 0.0125, // ~20px
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E293B),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.add, color: Colors.white, size: width * 0.015),
                style: IconButton.styleFrom(
                  backgroundColor: AppConstants.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(width * 0.005),
                  ),
                  padding: EdgeInsets.all(width * 0.005),
                ),
              ),
            ],
          ),
          SizedBox(height: width * 0.01),
          TextField(
            style: TextStyle(fontSize: width * 0.009),
            decoration: InputDecoration(
              hintText: 'Search name, email, or phone...',
              hintStyle: TextStyle(
                color: const Color(0xFF94A3B8),
                fontSize: width * 0.009,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: const Color(0xFF94A3B8),
                size: width * 0.012,
              ),
              filled: true,
              fillColor: const Color(0xFFF1F5F9), // gray-100
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(width * 0.005),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(vertical: width * 0.005),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerListItem(Map<String, dynamic> customer, double width) {
    final isSelected = customer['id'] == _selectedCustomerId;
    return InkWell(
      onTap: () => setState(() => _selectedCustomerId = customer['id']),
      child: Container(
        padding: EdgeInsets.all(width * 0.01), // ~16px
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor.withValues(alpha: 0.05)
              : Colors.transparent,
          border: Border(
            bottom: const BorderSide(color: Color(0xFFF1F5F9)),
            left: isSelected
                ? const BorderSide(color: AppConstants.primaryColor, width: 4)
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            Stack(
              children: [
                if (customer['image'] != null)
                  CircleAvatar(
                    radius: width * 0.015, // ~24px
                    backgroundImage: NetworkImage(customer['image']),
                  )
                else
                  CircleAvatar(
                    radius: width * 0.015, // ~24px
                    backgroundColor: Colors.blue.shade100,
                    child: Text(
                      customer['initials'] ?? 'CX',
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontWeight: FontWeight.bold,
                        fontSize: width * 0.01,
                      ),
                    ),
                  ),
                if (isSelected) // Mock online status
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: width * 0.0075, // ~12px
                      height: width * 0.0075,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        border: Border.all(color: Colors.white, width: 2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: width * 0.0075), // ~12px
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        customer['name'],
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: width * 0.009, // ~14px
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        '${customer['points']} pts',
                        style: TextStyle(
                          fontSize: width * 0.0075, // ~12px
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppConstants.primaryColor
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: width * 0.0015),
                  Text(
                    customer['email'],
                    style: TextStyle(
                      fontSize: width * 0.0075, // ~12px
                      color: const Color(0xFF64748B),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: width * 0.0015),
                  Text(
                    customer['phone'],
                    style: TextStyle(
                      fontSize: width * 0.0075, // ~12px
                      color: const Color(0xFF94A3B8),
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

  Widget _buildCustomerDetails(double width) {
    final customer = _customers.firstWhere(
      (c) => c['id'] == _selectedCustomerId,
      orElse: () => _customers[0],
    );

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(width * 0.02), // ~32px
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Card
                Container(
                  padding: EdgeInsets.all(width * 0.015), // ~24px
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width * 0.01),
                    border: Border.all(color: const Color(0xFFF1F5F9)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Large Avatar
                      Container(
                        width: width * 0.06, // ~96px
                        height: width * 0.06,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 4),
                          boxShadow: const [
                            BoxShadow(color: Colors.black12, blurRadius: 8),
                          ],
                          image: customer['image'] != null
                              ? DecorationImage(
                                  image: NetworkImage(customer['image']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: customer['image'] == null
                              ? Colors.blue.shade100
                              : null,
                        ),
                        child: customer['image'] == null
                            ? Center(
                                child: Text(
                                  customer['initials'] ?? 'CX',
                                  style: TextStyle(
                                    fontSize: width * 0.02, // ~32px
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade800,
                                  ),
                                ),
                              )
                            : null,
                      ),
                      SizedBox(width: width * 0.015),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  customer['name'],
                                  style: TextStyle(
                                    fontSize: width * 0.015, // ~24px
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F172A),
                                  ),
                                ),
                                SizedBox(width: width * 0.0075),
                                if (customer['isGold'] == true)
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: width * 0.006,
                                      vertical: width * 0.0012,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                        0xFFFEF9C3,
                                      ), // yellow-100
                                      borderRadius: BorderRadius.circular(
                                        width * 0.01,
                                      ),
                                      border: Border.all(
                                        color: const Color(0xFFFEF08A),
                                      ),
                                    ),
                                    child: Text(
                                      'Gold Member',
                                      style: TextStyle(
                                        fontSize: width * 0.0075, // ~12px
                                        fontWeight: FontWeight.w600,
                                        color: const Color(
                                          0xFF854D0E,
                                        ), // yellow-800
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            SizedBox(height: width * 0.005),
                            _buildInfoRow(
                              Icons.mail_outline,
                              customer['email'],
                              width,
                            ),
                            SizedBox(height: width * 0.0025),
                            _buildInfoRow(
                              Icons.call_outlined,
                              customer['phone'],
                              width,
                            ),
                            SizedBox(height: width * 0.0025),
                            _buildInfoRow(
                              Icons.location_on_outlined,
                              '102 Street 2714, New York, NY',
                              width,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: width * 0.015),
                      Row(
                        children: [
                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF334155),
                              side: const BorderSide(color: Color(0xFFCBD5E1)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  width * 0.005,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.01,
                                vertical: width * 0.01,
                              ),
                            ),
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(fontSize: width * 0.009),
                            ),
                          ),
                          SizedBox(width: width * 0.0075),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.shopping_bag_outlined,
                              size: width * 0.011,
                            ),
                            label: Text(
                              'New Order',
                              style: TextStyle(fontSize: width * 0.009),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryColor,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  width * 0.005,
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.01,
                                vertical: width * 0.01,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: width * 0.015),

                // Stats Grid
                Row(
                  children: [
                    _buildStatCard(
                      'Total Spent',
                      '\$4,250.00',
                      Icons.payments_outlined,
                      Colors.green,
                      const Color(0xFFDCFCE7), // green-100
                      width,
                      subtitle: '+12% vs last month',
                      subtitleColor: Colors.green,
                      subtitleIcon: Icons.trending_up,
                    ),
                    SizedBox(width: width * 0.01),
                    _buildStatCard(
                      'Visit Count',
                      '24',
                      Icons.storefront_outlined,
                      Colors.blue,
                      const Color(0xFFDBEAFE), // blue-100
                      width,
                      subtitle: 'Last visit: 2 days ago',
                    ),
                    SizedBox(width: width * 0.01),
                    _buildStatCard(
                      'Loyalty Points',
                      '1,250',
                      Icons.star_outline,
                      Colors.purple,
                      const Color(0xFFF3E8FF), // purple-100
                      width,
                      progressBar: 0.75,
                      footer: '750 pts to Platinum',
                    ),
                  ],
                ),

                SizedBox(height: width * 0.02),

                // Tabs (Visual Only for now)
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Row(
                    children: [
                      _buildTabItem(
                        'Purchase History',
                        Icons.receipt_long,
                        width,
                        isActive: true,
                      ),
                      SizedBox(width: width * 0.015),
                      _buildTabItem('Notes', Icons.edit_note, width),
                      SizedBox(width: width * 0.015),
                      _buildTabItem(
                        'Offers',
                        Icons.local_offer_outlined,
                        width,
                        badgeCount: 2,
                      ),
                    ],
                  ),
                ),

                // Table
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    border: Border(
                      left: BorderSide(color: Color(0xFFF1F5F9)),
                      right: BorderSide(color: Color(0xFFF1F5F9)),
                      bottom: BorderSide(color: Color(0xFFF1F5F9)),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildTableHeader(width),
                      _buildTableRow(
                        '#ORD-10234',
                        'Oct 24, 2023',
                        'Premium Coffee Kit, +2 more',
                        'Completed',
                        Colors.green,
                        '\$125.00',
                      ),
                      _buildTableRow(
                        '#ORD-09882',
                        'Oct 12, 2023',
                        'Espresso Machine Cleaner',
                        'Completed',
                        Colors.green,
                        '\$24.50',
                      ),
                      _buildTableRow(
                        '#ORD-09102',
                        'Sep 28, 2023',
                        'Vanilla Syrup 1L',
                        'Refunded',
                        Colors.amber,
                        '\$18.00',
                      ),
                      _buildTableRow(
                        '#ORD-08554',
                        'Sep 15, 2023',
                        'Ceramic Mug Set',
                        'Completed',
                        Colors.green,
                        '\$45.00',
                        isLast: true,
                      ),
                      // Pagination Footer
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        color: const Color(0xFFF8FAFC), // gray-50
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Showing 4 of 24 orders',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            Row(
                              children: [
                                OutlinedButton(
                                  onPressed: null,
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    minimumSize: const Size(0, 32),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFFCBD5E1),
                                    ),
                                  ),
                                  child: const Text(
                                    'Prev',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () {},
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    minimumSize: const Size(0, 32),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    side: const BorderSide(
                                      color: Color(0xFFCBD5E1),
                                    ),
                                    foregroundColor: const Color(0xFF64748B),
                                  ),
                                  child: const Text(
                                    'Next',
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(IconData icon, String text, double width) {
    return Row(
      children: [
        Icon(
          icon,
          size: width * 0.01, // ~16px
          color: const Color(0xFF94A3B8),
        ),
        SizedBox(width: width * 0.005),
        Text(
          text,
          style: TextStyle(
            fontSize: width * 0.009, // ~14px
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    IconData icon,
    Color color,
    Color bgColor,
    double width, {
    String? subtitle,
    Color? subtitleColor,
    IconData? subtitleIcon,
    double? progressBar,
    String? footer,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(width * 0.015), // ~24px
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(width * 0.01),
          border: Border.all(color: const Color(0xFFF1F5F9)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(width * 0.0075), // ~12px
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(width * 0.0075),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: width * 0.015, // ~24px
                  ),
                ),
                if (subtitleIcon != null)
                  Icon(subtitleIcon, color: subtitleColor, size: width * 0.01),
              ],
            ),
            SizedBox(height: width * 0.01),
            Text(
              value,
              style: TextStyle(
                fontSize: width * 0.015, // ~24px
                fontWeight: FontWeight.bold,
                color: const Color(0xFF0F172A),
              ),
            ),
            SizedBox(height: width * 0.0025),
            Text(
              title,
              style: TextStyle(
                fontSize: width * 0.009, // ~14px
                color: const Color(0xFF64748B),
              ),
            ),
            if (subtitle != null) ...[
              SizedBox(height: width * 0.0025),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: width * 0.0075, // ~12px
                  color: subtitleColor ?? const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (progressBar != null) ...[
              SizedBox(height: width * 0.0075),
              LinearProgressIndicator(
                value: progressBar,
                backgroundColor: const Color(0xFFF1F5F9),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: width * 0.003, // ~4px
                borderRadius: BorderRadius.circular(width * 0.0015),
              ),
              if (footer != null) ...[
                SizedBox(height: width * 0.005),
                Text(
                  footer,
                  style: TextStyle(
                    fontSize: width * 0.0075, // ~12px
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(
    String title,
    IconData icon,
    double width, {
    bool isActive = false,
    int? badgeCount,
  }) {
    return Container(
      padding: EdgeInsets.only(
        bottom: width * 0.01, // ~16px
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isActive ? AppConstants.primaryColor : Colors.transparent,
            width: 2,
          ),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: width * 0.012, // ~20px
            color: isActive
                ? AppConstants.primaryColor
                : const Color(0xFF64748B),
          ),
          SizedBox(width: width * 0.005),
          Text(
            title,
            style: TextStyle(
              fontSize: width * 0.009, // ~14px
              fontWeight: FontWeight.w600,
              color: isActive
                  ? AppConstants.primaryColor
                  : const Color(0xFF64748B),
            ),
          ),
          if (badgeCount != null) ...[
            SizedBox(width: width * 0.005),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.004,
                vertical: width * 0.0012,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(width * 0.006),
              ),
              child: Text(
                badgeCount.toString(),
                style: TextStyle(
                  fontSize: width * 0.0075, // ~12px
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTableHeader(double width) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.015,
        vertical: width * 0.0075,
      ), // ~24px, 12px
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
        color: Color(0xFFF8FAFC),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              'Order ID',
              style: TextStyle(
                fontSize: width * 0.0075, // ~12px
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Date',
              style: TextStyle(
                fontSize: width * 0.0075,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              'Items',
              style: TextStyle(
                fontSize: width * 0.0075,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Status',
              style: TextStyle(
                fontSize: width * 0.0075,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              'Total',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: width * 0.0075,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          SizedBox(width: width * 0.015), // Placeholder for chevron
        ],
      ),
    );
  }

  Widget _buildTableRow(
    String id,
    String date,
    String items,
    String status,
    Color statusColor,
    String total, {
    bool isLast = false,
  }) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.015,
        vertical: width * 0.01,
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              id,
              style: TextStyle(
                fontSize: width * 0.009, // ~14px
                fontWeight: FontWeight.w500,
                color: AppConstants.primaryColor,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              date,
              style: TextStyle(
                fontSize: width * 0.009, // ~14px
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          Expanded(
            flex: 4,
            child: Text(
              items,
              style: TextStyle(
                fontSize: width * 0.009, // ~14px
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.005,
                  vertical: width * 0.0015,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(width * 0.008),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: width * 0.0075, // ~12px
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              total,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: width * 0.009, // ~14px
                fontWeight: FontWeight.w500,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          SizedBox(
            width: width * 0.015,
            child: const Icon(Icons.chevron_right, color: Color(0xFF94A3B8)),
          ),
        ],
      ),
    );
  }
}
