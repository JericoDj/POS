import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../constants/app_constants.dart';
import '../../providers/subscription_provider.dart';

import '../paywall_screen.dart';

class SettingsSection extends StatefulWidget {
  const SettingsSection({super.key});

  @override
  State<SettingsSection> createState() => _SettingsSectionState();
}

class _SettingsSectionState extends State<SettingsSection> {
  bool _isDarkMode = false;
  bool _notificationsEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppConstants.backgroundLight,
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Settings',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: ListView(
              children: [
                _buildSectionTitle('Account'),
                _buildSettingsCard(
                  children: [
                    _buildListTile(
                      icon: Icons.person_outline,
                      title: 'Edit Profile',
                      subtitle: 'Change your name, email, and profile picture',
                      onTap: () => context.push('/profile'),
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    Consumer<SubscriptionProvider>(
                      builder: (context, subscription, child) {
                        final isPro = subscription.isPro;
                        return _buildListTile(
                          icon: isPro
                              ? Icons.star
                              : Icons.workspace_premium_outlined,
                          title: 'Subscription',
                          subtitle: isPro ? 'Pro Plan Active' : 'Free Plan',
                          // If pro, show amber star, else grey/default color
                          iconColor: isPro ? Colors.amber : null,
                          onTap: () {
                            // Option A: Direct Manage/Upgrade
                            if (isPro) {
                              // subscription.manageSubscription();
                              // Better UX: Show sheet with options
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => SafeArea(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: const Icon(
                                          Icons.manage_accounts,
                                        ),
                                        title: const Text(
                                          'Manage Subscription (Customer Center)',
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          PaywallScreen.present(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.open_in_new),
                                        title: const Text(
                                          'Manage in Store (Cancel/Upgrade)',
                                        ),
                                        onTap: () {
                                          Navigator.pop(context);
                                          PaywallScreen.present(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              PaywallScreen.present(context);
                            }
                          },
                        );
                      },
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildListTile(
                      icon: Icons.lock_outline,
                      title: 'Change Password',
                      subtitle: 'Update your security credentials',
                      onTap: () {},
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    _buildListTile(
                      icon: Icons.notifications_outlined,
                      title: 'Notifications',
                      subtitle: 'Manage your alert preferences',
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('Business'),
                _buildSettingsCard(
                  children: [
                    _buildListTile(
                      icon: Icons.business_center_outlined,
                      title: 'Manage Organizations',
                      subtitle: 'Switch, edit, or create businesses',
                      onTap: () => context.push('/business/manage'),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                _buildSectionTitle('App Settings'),
                _buildSettingsCard(
                  children: [
                    SwitchListTile(
                      value: _isDarkMode,
                      onChanged: (value) => setState(() => _isDarkMode = value),
                      title: const Text('Dark Mode'),
                      secondary: const Icon(
                        Icons.dark_mode_outlined,
                        color: Color(0xFF64748B),
                      ),
                      activeColor: AppConstants.primaryColor,
                    ),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    SwitchListTile(
                      value: _notificationsEnabled,
                      onChanged: (value) =>
                          setState(() => _notificationsEnabled = value),
                      title: const Text('Notifications'),
                      subtitle: const Text('Receive alerts for new orders'),
                      secondary: const Icon(
                        Icons.notifications_outlined,
                        color: Color(0xFF64748B),
                      ),
                      activeColor: AppConstants.primaryColor,
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // _buildSectionTitle('Business'),
                // _buildSettingsCard(
                //   children: [
                //     _buildListTile(
                //       icon: Icons.storefront_outlined,
                //       title: 'Store Information',
                //       subtitle: 'Update store name, address, and contact info',
                //       onTap: () {},
                //     ),
                //     const Divider(height: 1, color: Color(0xFFF1F5F9)),
                //     _buildListTile(
                //       icon: Icons.receipt_long_outlined,
                //       title: 'Tax & Receipts',
                //       subtitle: 'Configure tax rates and receipt settings',
                //       onTap: () {},
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF64748B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 20,
          color: iconColor ?? const Color(0xFF64748B),
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Color(0xFF0F172A),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 20,
        color: Color(0xFF94A3B8),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
