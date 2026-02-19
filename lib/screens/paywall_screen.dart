import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_provider.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

class PaywallScreen extends StatefulWidget {
  const PaywallScreen({super.key});

  static Future<void> present(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const PaywallScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  State<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends State<PaywallScreen> {
  @override
  void initState() {
    super.initState();
    // Ensure products are fetched when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SubscriptionProvider>().init();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upgrade Plan'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        // actions: [
        //   TextButton(
        //     onPressed: () {
        //       context.read<SubscriptionProvider>().restorePurchases();
        //     },
        //     child: const Text("Restore"),
        //   ),
        //   // Debug option to reset
        //   IconButton(
        //     icon: const Icon(Icons.refresh),
        //     tooltip: 'Reset to Free (Debug)',
        //     onPressed: () {
        //       context.read<SubscriptionProvider>().setTier(
        //         SubscriptionTier.free,
        //       );
        //     },
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTierCard(
              context,
              title: 'Free',
              price: '\$0 / month',
              description: 'Trial but usable',
              features: [
                '100 orders / month',
                '50 products',
                '1 device',
                'Basic receipt',
                'Daily sales report only',
              ],
              tier: SubscriptionTier.free,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Consumer<SubscriptionProvider>(
              builder: (context, provider, child) {
                ProductDetails? product;
                bool isAvailable = false;
                try {
                  product = provider.products.firstWhere(
                    (p) => p.id == 'leos_pos_starter_plan',
                  );
                  isAvailable = true;
                } catch (e) {
                  // Fallback for display only
                  product = ProductDetails(
                    id: 'leos_pos_starter_plan',
                    title: 'Starter',
                    description: 'Starter Plan',
                    price: '\$19.99',
                    rawPrice: 19.99,
                    currencyCode: 'USD',
                  );
                  isAvailable = false;
                }

                return _buildTierCard(
                  context,
                  title: 'Starter',
                  price: isAvailable
                      ? '${product.price} / month'
                      : '\$19.99 / month',
                  description: 'For small real stores',
                  features: [
                    'Unlimited orders',
                    '500 products',
                    '2 devices',
                    'Basic reports',
                    'Inventory tracking',
                    'Expenses',
                    'Manual Backup',
                  ],
                  tier: SubscriptionTier.starter,
                  color: Colors.green,
                  product: isAvailable ? product : null,
                  isAvailable: isAvailable,
                );
              },
            ),
            // ... (Other tiers commented out or displayed as info only)
            const SizedBox(height: 16),
            // _buildTierCard(
            //   context,
            //   title: 'Pro',
            //   price: '\$59.99 / month',
            //   description: 'Main plan (most customers)',
            //   features: [
            //     'Unlimited orders',
            //     'Unlimited products',
            //     '5 staff accounts',
            //     'Advanced reports',
            //     'Profit analytics',
            //     'Supplier management',
            //     'Stock alerts',
            //     'Customer list',
            //     'Automatic backups',
            //     'Bluetooth printing',
            //     'Discounts & promos',
            //   ],
            //   tier: SubscriptionTier.pro,
            //   color: Colors.blue,
            //   isPopular: true,
            // ),
            // const SizedBox(height: 16),
            // _buildTierCard(
            //   context,
            //   title: 'Business',
            //   price: '\$119.99 / month',
            //   description: 'Serious business',
            //   features: [
            //     'Everything in Pro',
            //     'Unlimited staff',
            //     'Multi-device unlimited',
            //     'Kitchen display / order queue',
            //     'Role permissions',
            //     'Audit logs',
            //     'Branch support (1 main + 1 sub)',
            //     'Cloud sync real-time',
            //   ],
            //   tier: SubscriptionTier.business,
            //   color: Colors.purple,
            // ),
            // const SizedBox(height: 16),
            // _buildTierCard(
            //   context,
            //   title: 'Enterprise',
            //   price: '\$199.99  / month',
            //   description: 'Chains',
            //   features: [
            //     'Multi-branch unlimited',
            //     'Central dashboard',
            //     'Remote monitoring',
            //     'Priority support',
            //     'Data export API',
            //     'White-label',
            //   ],
            //   tier: SubscriptionTier.enterprise,
            //   color: Colors.orange,
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildTierCard(
    BuildContext context, {
    required String title,
    required String price,
    required String description,
    required List<String> features,
    required SubscriptionTier tier,
    required Color color,
    bool isPopular = false,
    bool isAvailable = true,
    ProductDetails? product,
  }) {
    final currentTier = context.watch<SubscriptionProvider>().currentTier;
    final isCurrent = currentTier == tier;

    return Card(
      elevation: isPopular ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isPopular ? BorderSide(color: color, width: 2) : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isPopular)
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'MOST POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (isPopular) const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 16, color: color),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  (tier == SubscriptionTier.free ||
                      (product != null && isAvailable))
                  ? () {
                      if (tier == SubscriptionTier.free) {
                        context.read<SubscriptionProvider>().setTier(tier);
                        Navigator.of(context).pop();
                      } else {
                        context.read<SubscriptionProvider>().buyProduct(
                          product!,
                        );
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCurrent ? Colors.green.shade800 : color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                isCurrent
                    ? 'Current Plan (Tap to Manage)'
                    : (product == null && tier != SubscriptionTier.free)
                    ? 'Unavailable'
                    : 'Select Plan',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
