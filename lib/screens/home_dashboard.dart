import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/app_dimensions.dart';
import 'home_sections/sales_section.dart';
import 'home_sections/reports_section.dart';
import 'home_sections/inventory_section.dart';

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
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),

          // Main Content Area
          Expanded(child: _getSelectedSection()),
        ],
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
        return const Center(child: Text('Customers Module Coming Soon'));
      case 4:
        return const Center(child: Text('Settings Module Coming Soon'));
      default:
        return const SalesSection();
    }
  }

  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _isCollapsed ? 80 : 250,
      decoration: BoxDecoration(
        color: AppConstants.slate900,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Area
          SizedBox(
            height: 80,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.coffee,
                    color: AppConstants.primaryColor,
                    size: 32,
                  ),
                  if (!_isCollapsed) ...[
                    const SizedBox(width: 12),
                    const Text(
                      "Queen's Cafe",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Playfair Display',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          const Divider(color: AppConstants.slate800),

          // Navigation
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24),
              children: [
                _buildMenuItem(Icons.point_of_sale, 'Sales', 0),
                _buildMenuItem(Icons.inventory_2, 'Inventory', 1),
                _buildMenuItem(Icons.bar_chart, 'Reports', 2),
                _buildMenuItem(Icons.people, 'Customers', 3),
                _buildMenuItem(Icons.settings, 'Settings', 4),
              ],
            ),
          ),

          // Collapse Toggle
          Container(
            padding: const EdgeInsets.all(16),
            child: IconButton(
              onPressed: () => setState(() => _isCollapsed = !_isCollapsed),
              icon: Icon(
                _isCollapsed ? Icons.chevron_right : Icons.chevron_left,
                color: AppConstants.slate500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, int index) {
    final isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryColor.withValues(alpha: 0.1)
              : Colors.transparent,
          border: Border(
            left: BorderSide(
              color: isSelected
                  ? AppConstants.primaryColor
                  : Colors.transparent,
              width: 4,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppConstants.primaryColor
                  : AppConstants.slate500,
              size: 24,
            ),
            if (!_isCollapsed) ...[
              const SizedBox(width: 16),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppConstants.slate500,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 16,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
