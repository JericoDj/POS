import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_dimensions.dart';
import 'home_sections/sales_section.dart';
import 'home_sections/sales_history_section.dart';
import 'home_sections/reports_section.dart';
import 'home_sections/inventory_section.dart';
import 'home_sections/customers_section.dart';
import 'home_sections/settings_section.dart';
import 'home_sections/dashboard_header.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';
import '../providers/business_provider.dart';
import '../models/business_model.dart';

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

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppConstants.backgroundLight,
        body: Column(
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
      case 7:
        return const SalesHistorySection();
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
            child: Row(
              mainAxisAlignment: _isCollapsed
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                if (!_isCollapsed)
                  Expanded(
                    child: Consumer<BusinessProvider>(
                      builder: (context, businessProvider, child) {
                        return PopupMenuButton<dynamic>(
                          offset: const Offset(0, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.grey.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.withValues(alpha: 0.05),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: AppConstants.primaryColor,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    (businessProvider.currentBusiness?.name ??
                                            AppConstants.appName)[0]
                                        .toUpperCase(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    businessProvider.currentBusiness?.name ??
                                        AppConstants.appName,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: AppConstants.slate800,
                                      fontFamily: 'Inter',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down,
                                  size: 16,
                                  color: AppConstants.slate500,
                                ),
                              ],
                            ),
                          ),
                          onSelected: (value) {
                            if (value is BusinessModel) {
                              businessProvider.switchBusiness(value);
                            } else if (value == 'new_org') {
                              context.push('/business/create');
                            } else if (value == 'settings') {
                              context.push('/profile');
                            } else if (value == 'logout') {
                              context.read<AuthProvider>().logout();
                              context.go('/login');
                            }
                          },
                          itemBuilder: (context) {
                            return [
                              ...businessProvider.businesses.map(
                                (business) => PopupMenuItem(
                                  value: business,
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 24,
                                        height: 24,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.grey.withValues(
                                              alpha: 0.2,
                                            ),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          business.name.isNotEmpty
                                              ? business.name[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          business.name,
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (business.id ==
                                          businessProvider.currentBusiness?.id)
                                        const Icon(
                                          Icons.check,
                                          size: 16,
                                          color: AppConstants.primaryColor,
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const PopupMenuDivider(),
                              const PopupMenuItem(
                                value: 'new_org',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.add,
                                      size: 20,
                                      color: AppConstants.slate500,
                                    ),
                                    SizedBox(width: 12),
                                    Text('New Organization'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'settings',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.settings,
                                      size: 20,
                                      color: AppConstants.slate500,
                                    ),
                                    SizedBox(width: 12),
                                    Text('Account Settings'),
                                  ],
                                ),
                              ),
                              const PopupMenuDivider(),
                              const PopupMenuItem(
                                value: 'logout',
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.logout,
                                      size: 20,
                                      color: Colors.red,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Logout',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                              ),
                            ];
                          },
                        );
                      },
                    ),
                  ),
                if (!_isCollapsed) const SizedBox(width: 8),
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
                _buildMenuItem(Icons.point_of_sale, 'POS', 0),
                const SizedBox(height: 4),
                _buildMenuItem(
                  Icons.receipt_long,
                  'Sales',
                  7,
                ), // New Sales History
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
        ? primaryColor.withValues(alpha: 0.1)
        : (isDestructive ? Colors.red.shade50 : Colors.transparent);

    return InkWell(
      onTap: () {
        if (index == 6) {
          // Logout
          context.read<AuthProvider>().logout();
          context.go('/login');
        } else {
          setState(() => _selectedIndex = index);
        }
      },
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
