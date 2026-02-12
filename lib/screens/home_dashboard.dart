import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_dimensions.dart';
import 'home_sections/sales_section.dart';
import 'home_sections/reports_section.dart';
import 'home_sections/inventory_section.dart';
import 'home_sections/customers_section.dart';
import 'home_sections/settings_section.dart';
import 'home_sections/dashboard_header.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  bool _isCollapsed = false;
  int _selectedIndex =
      0; // 0: Sales, 1: Inventory, 2: Reports, 3: Customers, 4: Settings

  @override
  Widget build(BuildContext context) {
    AppDimensions().init(context);

    return Scaffold(
      backgroundColor: AppConstants.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header (App Bar)
            const DashboardHeader(),

            // Main Layout (Sidebar + Content)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sidebar
                  _buildSidebar(),

                  // Main Content Area
                  Expanded(
                    child: Container(
                      color: AppConstants.backgroundLight,
                      child: _getSelectedSection(),
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

  Widget _getSelectedSection() {
    switch (_selectedIndex) {
      case 0:
        return const SalesSection();
      case 1:
        return const InventorySection();
      case 2:
        return const ReportsSection();
      case 3:
        return const CustomersSection();
      case 4:
        return const SettingsSection();
      case 5:
        return const Center(
          child: Text('Admin Functions (User Management, etc.)'),
        );
      case 6:
        return const Center(child: Text('Logging out...'));
      default:
        return const SalesSection();
    }
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isCollapsed ? 80 : 256, // w-20 vs w-64 (64 * 4 = 256)
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Color(0xFFE5E7EB)), // border-gray-200
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Header / Toggle Area
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
            child: Row(
              mainAxisAlignment: _isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (!_isCollapsed)
                  const Text(
                    "Queen's Cafe",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.slate800,
                      fontFamily: 'Inter',
                    ),
                  ),
                InkWell(
                  onTap: () => setState(() => _isCollapsed = !_isCollapsed),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.transparent,
                    ),
                    child: Icon(
                      _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                      color: AppConstants.slate400,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: [
                _buildMenuItem(Icons.storefront, 'Sales', 0),
                const SizedBox(height: 4),
                _buildMenuItem(Icons.inventory_2_outlined, 'Inventory', 1),
                const SizedBox(height: 4),
                _buildMenuItem(Icons.people_outline, 'Customers', 3),
                const SizedBox(height: 4),
                _buildMenuItem(Icons.bar_chart, 'Reports', 2),
              ],
            ),
          ),

          // Bottom Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Column(
              children: [
                if (!_isCollapsed) ...[
                  // Pro Plan Card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFEEF2FF),
                          Color(0xFFFAF5FF),
                        ], // indigo-50 to purple-50
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE0E7FF),
                      ), // indigo-100
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 2),
                            ],
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Pro Plan',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.slate800,
                                ),
                              ),
                              Text(
                                'Active until Dec 31',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: AppConstants.slate500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Bottom Menu Items
                _buildMenuItem(Icons.settings_outlined, 'Settings', 4),
                const SizedBox(height: 4),
                _buildMenuItem(Icons.security, 'Admin Functions', 5),
                const SizedBox(height: 4),
                _buildMenuItem(Icons.logout, 'Logout', 6, isDestructive: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    int index, {
    bool isDestructive = false,
  }) {
    final isSelected = _selectedIndex == index;
    final primaryColor = isDestructive ? Colors.red : AppConstants.primaryColor;
    final textColor = isSelected
        ? primaryColor
        : (isDestructive ? Colors.red.shade600 : AppConstants.slate500);
    final bgColor = isSelected
        ? primaryColor.withOpacity(0.1)
        : (isDestructive ? Colors.red.shade50 : Colors.transparent);

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: _isCollapsed
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: textColor),
            if (!_isCollapsed) ...[
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
