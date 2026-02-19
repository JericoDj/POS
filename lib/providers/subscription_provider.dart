import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'auth_provider.dart';
import 'business_provider.dart';

enum SubscriptionTier { free, starter, pro, business, enterprise }

class SubscriptionProvider extends ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<ProductDetails> _products = [];
  bool _isAvailable = false;
  bool _isLoading = true;
  BusinessProvider? _businessProvider;
  AuthProvider? _authProvider;

  // Product IDs
  static const String _starterPlanId = 'leos_pos_starter_plan';
  static const Set<String> _kIds = {_starterPlanId};

  bool get isLoading => _isLoading;
  bool get isAvailable => _isAvailable;
  List<ProductDetails> get products => _products;

  SubscriptionTier get currentTier {
    if (_businessProvider?.currentBusiness?.subscription != null) {
      final tier = _businessProvider?.currentBusiness?.subscription?['tier'];
      if (tier == 'starter') return SubscriptionTier.starter;
      // Add other tiers here if needed
    }
    return SubscriptionTier.free;
  }

  bool get isPro => currentTier != SubscriptionTier.free;

  // Features based on tier
  int get maxOrders {
    switch (currentTier) {
      case SubscriptionTier.free:
        return 100;
      case SubscriptionTier.starter:
        return -1;
      case SubscriptionTier.pro:
        return -1;
      case SubscriptionTier.business:
        return -1;
      case SubscriptionTier.enterprise:
        return -1;
    }
  }

  int get maxProducts {
    switch (currentTier) {
      case SubscriptionTier.free:
        return 50;
      case SubscriptionTier.starter:
        return 500;
      case SubscriptionTier.pro:
        return -1;
      case SubscriptionTier.business:
        return -1;
      case SubscriptionTier.enterprise:
        return -1;
    }
  }

  int get maxStaff {
    switch (currentTier) {
      case SubscriptionTier.free:
        return 0;
      case SubscriptionTier.starter:
        return 0;
      case SubscriptionTier.pro:
        return 5;
      case SubscriptionTier.business:
        return -1;
      case SubscriptionTier.enterprise:
        return -1;
    }
  }

  Future<void> init() async {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        debugPrint('Error listening to purchase stream: $error');
      },
    );

    await _initStore();
  }

  void update(BusinessProvider businessProvider, AuthProvider authProvider) {
    _businessProvider = businessProvider;
    _authProvider = authProvider;
    // No need to notifyListeners here usually, unless business changed, which BusinessProvider handles?
    // Main.dart calls this on rebuild.
    // If the business provider updates, this update is called.
    notifyListeners();
  }

  Future<void> _initStore() async {
    print('--- IAP: initializing store ---');
    _isAvailable = await _inAppPurchase.isAvailable();
    print('--- IAP: isAvailable: $_isAvailable ---');
    if (!_isAvailable) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    const Set<String> ids = _kIds;
    print('--- IAP: Querying products: $ids ---');
    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(ids);

    if (response.error != null) {
      print('--- IAP: Query Error: ${response.error!.message} ---');
    }

    if (response.notFoundIDs.isNotEmpty) {
      print('--- IAP: Products not found: ${response.notFoundIDs} ---');
    }

    _products = response.productDetails;
    print('--- IAP: Found ${_products.length} products ---');
    for (var p in _products) {
      print('--- IAP Product: ${p.id} - ${p.title} - ${p.price} ---');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    // For subscriptions, allow auto-consumption to be false (default for non-consumables)
    // documentation says strictly use buyNonConsumable for subscriptions on iOS
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
    purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
      print('--- IAP STATUS: ${purchaseDetails.status} ---');
      print('--- IAP ID: ${purchaseDetails.purchaseID} ---');

      if (purchaseDetails.status == PurchaseStatus.pending) {
        print('--- IAP: Purchase Pending... UI should behave accordingly ---');
        // Show pending UI if needed
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          print('--- IAP: Purchase ERROR: ${purchaseDetails.error} ---');
          debugPrint('Purchase error: ${purchaseDetails.error}');
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          print('--- IAP: SUCCESS! (Status: ${purchaseDetails.status}) ---');

          if (purchaseDetails.productID == _starterPlanId) {
            if (_businessProvider != null &&
                _businessProvider!.currentBusiness != null) {
              try {
                // 1. Update Business Subscription
                final subscriptionData = {
                  'tier': 'starter',
                  'status': 'active',
                  'updatedAt': DateTime.now().toIso8601String(),
                  'provider': 'apple_storekit',
                  'purchaseId': purchaseDetails.purchaseID,
                };

                // OPTIMISTIC UPDATE (PER USER REQUEST)
                _businessProvider!.updateSubscriptionLocally(subscriptionData);

                // Try Backend Update (Silence errors for now)
                /*
                await _businessProvider!.updateCurrentBusinessSubscription(
                  subscriptionData,
                );
                */

                // 2. Update User Subscription ID
                if (_authProvider != null &&
                    purchaseDetails.purchaseID != null) {
                  // await _authProvider!.updateUserSubscription(purchaseDetails.purchaseID!);
                }
              } catch (e) {
                // debugPrint('Failed to update subscription in DB: $e');
              }
            }
            notifyListeners();
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    });
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  // Method to set tier manually (for testing or other logic)
  void setTier(SubscriptionTier tier) {
    if (_businessProvider != null) {
      if (tier == SubscriptionTier.free) {
        _businessProvider!.updateCurrentBusinessSubscription({
          'tier': 'free',
          'status': 'active',
        });
      } else if (tier == SubscriptionTier.starter) {
        _businessProvider!.updateCurrentBusinessSubscription({
          'tier': 'starter',
          'status': 'active',
        });
      }
    }
    notifyListeners();
  }
}
