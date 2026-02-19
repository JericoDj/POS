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
import '../providers/subscription_provider.dart';
import 'paywall_screen.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  bool _isCollapsed = false;
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    AppDimensions().init(context);

    // This is a simple breakpoint. You can adjust or use AppDimensions
    final isDesktop =
        MediaQuery.of(context).size.width >= 800; // landscape tablet / desktop

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppConstants.backgroundLight,
      drawer: !isDesktop
          ? Drawer(
              width: 280,
              backgroundColor: Colors.white,
              child: SafeArea(child: _buildSidebarContent(isDrawer: true)),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            // Top Header (App Bar)
            DashboardHeader(
              onMenuPressed: !isDesktop
                  ? () => _scaffoldKey.currentState?.openDrawer()
                  : null,
            ),

            // Main Layout (Sidebar + Content)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isDesktop) _buildSidebar(),

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

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isCollapsed ? 80 : 256,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(right: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: _buildSidebarContent(isDrawer: false),
    );
  }

  Widget _buildSidebarContent({required bool isDrawer}) {
    return Column(
      children: [
        // Header for Drawer or Sidebar
        if (isDrawer) const SizedBox(height: 16),

        // ... Logic for Business Switcher ...
        _buildBusinessSwitcher(isDrawer),

        const SizedBox(height: 8),

        // Navigation Items
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            children: [
              _buildMenuItem(Icons.point_of_sale, 'POS', 0, isDrawer),
              const SizedBox(height: 4),
              _buildMenuItem(
                Icons.inventory_2_outlined,
                'Inventory',
                1,
                isDrawer,
              ),
              const SizedBox(height: 4),
              // _buildMenuItem(Icons.bar_chart, 'Reports', 2, isDrawer),
              // const SizedBox(height: 4),
              // _buildMenuItem(Icons.people_outline, 'Customers', 3, isDrawer),
              // const SizedBox(height: 4),
              _buildMenuItem(Icons.receipt_long, 'Sales', 7, isDrawer),
            ],
          ),
        ),

        // Bottom Section
        _buildBottomSection(isDrawer),
      ],
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

  Widget _buildBusinessSwitcher(bool isDrawer) {
    if (isDrawer) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Consumer<BusinessProvider>(
          builder: (context, businessProvider, child) {
            final business = businessProvider.currentBusiness;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppConstants.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        (business?.name.isNotEmpty == true
                                ? business!.name
                                : AppConstants.appName)[0]
                            .toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            business?.name ?? AppConstants.appName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.slate800,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Text(
                            'Tap to switch',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppConstants.slate500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(),
              ],
            );
          },
        ),
      );
    }

    // Original Sidebar switcher logic
    return Padding(
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
                              (businessProvider
                                              .currentBusiness
                                              ?.name
                                              .isNotEmpty ==
                                          true
                                      ? businessProvider.currentBusiness!.name
                                      : AppConstants.appName)[0]
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
                      } else if (value == 'settings') {
                        context.push('/profile');
                      } else if (value == 'new_org') {
                        context.push('/business/manage');
                      }
                    },
                    itemBuilder: (context) {
                      return [
                        ...businessProvider.businesses.map(
                          (business) => PopupMenuItem<dynamic>(
                            value: business,
                            child: Row(
                              children: [
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color:
                                        business.id ==
                                            businessProvider.currentBusiness?.id
                                        ? AppConstants.primaryColor
                                        : const Color(0xFFE2E8F0),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    (business.name.isNotEmpty
                                            ? business.name
                                            : '?')[0]
                                        .toUpperCase(),
                                    style: TextStyle(
                                      color:
                                          business.id ==
                                              businessProvider
                                                  .currentBusiness
                                                  ?.id
                                          ? Colors.white
                                          : const Color(0xFF475569),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    business.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight:
                                          business.id ==
                                              businessProvider
                                                  .currentBusiness
                                                  ?.id
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
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
                        const PopupMenuItem<dynamic>(
                          value: 'new_org',
                          child: Row(
                            children: [
                              Icon(
                                Icons.add_business,
                                size: 20,
                                color: AppConstants.primaryColor,
                              ),
                              SizedBox(width: 12),
                              Text(
                                'Manage Organizations',
                                style: TextStyle(
                                  color: AppConstants.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<dynamic>(
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
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    int index,
    bool isDrawer, {
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
          if (isDrawer) {
            Navigator.pop(context); // Close drawer
          }
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
          mainAxisAlignment: (_isCollapsed && !isDrawer)
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            Icon(icon, size: 24, color: textColor),
            if (isDrawer || !_isCollapsed) ...[
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

  Widget _buildBottomSection(bool isDrawer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          if (isDrawer || !_isCollapsed) ...[
            // Pro Plan Card
            Consumer<SubscriptionProvider>(
              builder: (context, subscription, child) {
                final isPro = subscription.isPro;
                return InkWell(
                  onTap: () {
                    if (isPro) {
                      PaywallScreen.present(context);
                    } else {
                      PaywallScreen.present(context);
                    }
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isPro
                            ? [const Color(0xFFEEF2FF), const Color(0xFFFAF5FF)]
                            : [Colors.grey.shade100, Colors.grey.shade200],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isPro
                            ? const Color(0xFFE0E7FF)
                            : Colors.grey.shade300,
                      ),
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
                          child: Icon(
                            isPro ? Icons.star : Icons.lock_outline,
                            color: isPro ? Colors.amber : Colors.grey,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isPro ? 'Pro Plan' : 'Free Plan',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppConstants.slate800,
                                ),
                              ),
                              Text(
                                isPro ? 'Manage Subscription' : 'Upgrade Now',
                                style: const TextStyle(
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
                );
              },
            ),
            const SizedBox(height: 16),
          ],

          // Bottom Menu Items
          _buildMenuItem(Icons.settings_outlined, 'Settings', 4, isDrawer),
          const SizedBox(height: 4),
          // _buildMenuItem(Icons.security, 'Admin Functions', 5, isDrawer),
          // const SizedBox(height: 4),
          _buildMenuItem(
            Icons.logout,
            'Logout',
            6,
            isDrawer,
            isDestructive: true,
          ),
        ],
      ),
    );
  }
}
