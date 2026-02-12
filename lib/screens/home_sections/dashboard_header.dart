import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64, // h-16
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFE5E7EB)), // border-gray-200
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Section: Logo & Search
          Expanded(
            child: Row(
              children: [
                // Branding
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppConstants.primaryColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.point_of_sale,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),

                Text(      AppConstants.appName, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppConstants.slate800,
                )),
                const SizedBox(width: 32),

                // Search Bar (Hidden on small screens - simplified for Flutter)
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search products, orders, or customers...',
                        hintStyle: const TextStyle(
                          color: AppConstants.slate500,
                          fontSize: 14,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: AppConstants.slate500,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: AppConstants.backgroundLight,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 0,
                          horizontal: 12,
                        ),
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right Section: Status & Profile
          Row(
            children: [
              // Status Indicators
              _buildStatusPill(
                icon: Icons.wifi,
                label: 'Online',
                iconColor: Colors.green,
              ),
              const SizedBox(width: 16),
              _buildStatusPill(
                icon: Icons.battery_full,
                label: '100%',
                iconColor: AppConstants.slate500,
              ),

              // Divider
              Container(
                height: 32,
                width: 1,
                color: const Color(0xFFE5E7EB), // gray-200
                margin: const EdgeInsets.symmetric(horizontal: 16),
              ),

              // Profile
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(24),
                child: Row(
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Alex M.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppConstants.slate800,
                          ),
                        ),
                        Text(
                          'Cashier #4',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppConstants.slate500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                          ),
                        ],
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://lh3.googleusercontent.com/aida-public/AB6AXuA9fCq8karq8JnuGckFpO_S9D0kRe1ugSA9oNV_bgrjsVFJ4HsKKNDULHCxSUWxeJBFXvz0f3BqAK29EL8_rB9to-RO3moSaurkh5P-UkA0DyBHPp5Wsw-7map3JvOAT1MwVgRAL1s5AzL1fr2EIJjxkn-KCzaX_iQyfUDdHTkFcWGODEesDyPYxAVf36c2PRmGMtxZLHtYY0JlUuN-GiboCen6cYJZN-5TZ9tbUG9XscrxRV8imZrtFTRFBLcdGaMwhC4YyHwN3kAa',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusPill({
    required IconData icon,
    required String label,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppConstants.backgroundLight,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 18),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppConstants.slate500,
            ),
          ),
        ],
      ),
    );
  }
}
