import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../constants/app_constants.dart';
import '../../providers/business_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/business_model.dart';

class DashboardHeader extends StatefulWidget {
  final VoidCallback? onMenuPressed;

  const DashboardHeader({super.key, this.onMenuPressed});

  @override
  State<DashboardHeader> createState() => _DashboardHeaderState();
}

class _DashboardHeaderState extends State<DashboardHeader>
    with SingleTickerProviderStateMixin {
  bool _showSearch = false;
  late AnimationController _searchAnimController;
  late Animation<double> _searchAnimation;

  @override
  void initState() {
    super.initState();
    _searchAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _searchAnimation = CurvedAnimation(
      parent: _searchAnimController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchAnimController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _showSearch = !_showSearch;
      if (_showSearch) {
        _searchAnimController.forward();
      } else {
        _searchAnimController.reverse();
      }
    });
  }

  bool _isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 800;
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _isMobile(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isMobile) _buildMobileHeader(context),
          if (!isMobile) _buildDesktopHeader(context),
          // Animated search drawer (mobile only)
          if (isMobile)
            SizeTransition(
              sizeFactor: _searchAnimation,
              axisAlignment: -1.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: TextField(
                  autofocus: true,
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
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.close, size: 20),
                      onPressed: _toggleSearch,
                      color: AppConstants.slate500,
                    ),
                    filled: true,
                    fillColor: AppConstants.backgroundLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppConstants.primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppConstants.primaryColor.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: AppConstants.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Mobile: Menu | Business Switcher | Search Icon
  Widget _buildMobileHeader(BuildContext context) {
    return Row(
      children: [
        // Menu button
        if (widget.onMenuPressed != null)
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: widget.onMenuPressed,
            color: AppConstants.slate800,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        if (widget.onMenuPressed != null) const SizedBox(width: 12),

        const Spacer(),
        // Business Switcher
        Consumer<BusinessProvider>(
          builder: (context, businessProvider, child) {
            final currentBusiness = businessProvider.currentBusiness;
            return PopupMenuButton<dynamic>(
              offset: const Offset(0, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
              ),
              child: Column(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: AppConstants.primaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      (currentBusiness?.name.isNotEmpty == true
                              ? currentBusiness!.name
                              : "No Organization")[0]
                          .toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          currentBusiness?.name ?? "No Organization",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.slate800,
                                fontSize: 14,
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
                ],
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
                                        businessProvider.currentBusiness?.id
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
                                        businessProvider.currentBusiness?.id
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
                          style: TextStyle(color: AppConstants.primaryColor),
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

        const Spacer(),

        // Search icon
        IconButton(
          icon: Icon(
            _showSearch ? Icons.search_off : Icons.search,
            color: AppConstants.slate800,
          ),
          onPressed: _toggleSearch,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  /// Desktop/Tablet: Full row with branding, search bar, status, profile
  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left Section: Menu + Logo + Search
        Expanded(
          child: Row(
            children: [
              if (widget.onMenuPressed != null)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: IconButton(
                    iconSize: 16,
                    icon: const Icon(Icons.menu),
                    onPressed: widget.onMenuPressed,
                    color: AppConstants.slate800,
                  ),
                ),

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
              Consumer<BusinessProvider>(
                builder: (context, businessProvider, child) {
                  return Text(
                    businessProvider.currentBusiness?.name ?? "No Organization",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppConstants.slate800,
                    ),
                  );
                },
              ),
              const SizedBox(width: 32),

              // Search Bar
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
            _buildStatusPill(
              icon: Icons.wifi,
              label: 'Online',
              iconColor: Colors.green,
            ),
            const SizedBox(width: 16),

            // Divider
            Container(
              height: 32,
              width: 1,
              color: const Color(0xFFE5E7EB),
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),

            // Profile
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                final user = authProvider.user;
                return InkWell(
                  onTap: () {
                    context.push('/profile');
                  },
                  borderRadius: BorderRadius.circular(24),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user?.displayName ?? 'User',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppConstants.slate800,
                            ),
                          ),
                          Text(
                            user?.email ?? '',
                            style: const TextStyle(
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
                          color: user?.photoURL != null
                              ? Colors.transparent
                              : AppConstants.primaryColor,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 4,
                            ),
                          ],
                          image: user?.photoURL != null
                              ? DecorationImage(
                                  image: NetworkImage(user!.photoURL!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        alignment: Alignment.center,
                        child: user?.photoURL == null
                            ? Text(
                                (user?.displayName?.isNotEmpty == true
                                        ? user!.displayName!
                                        : "U")[0]
                                    .toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : null,
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ],
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
