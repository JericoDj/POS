import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_dimensions.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';

import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/sales_provider.dart';
import '../../models/sale_model.dart';

class SalesSection extends StatefulWidget {
  const SalesSection({super.key});

  @override
  State<SalesSection> createState() => _SalesSectionState();
}

class _SalesSectionState extends State<SalesSection> {
  // State
  String? _selectedCategoryId; // null means 'All Items'
  final List<CartItem> _cart = [];

  @override
  void initState() {
    super.initState();
    // Fetch data when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryProvider>().fetchCategories();
      context.read<ProductProvider>().fetchProducts();
    });
  }

  void _addToCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((item) => item.product.id == product.id);
      if (index >= 0) {
        _cart[index].quantity++;
      } else {
        _cart.add(CartItem(product: product));
      }
    });
  }

  void _removeFromCart(Product product) {
    setState(() {
      final index = _cart.indexWhere((item) => item.product.id == product.id);
      if (index >= 0) {
        if (_cart[index].quantity > 1) {
          _cart[index].quantity--;
        } else {
          _cart.removeAt(index);
        }
      }
    });
  }

  void _clearCart() {
    setState(() {
      _cart.clear();
    });
  }

  Future<void> _processCheckout() async {
    if (_cart.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cart is empty')));
      return;
    }

    if (_total.isNaN || _total.isInfinite) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Error: Invalid total amount. Please check product prices.',
          ),
        ),
      );
      return;
    }

    try {
      final saleItems = _cart.map((cartItem) {
        return SaleItem(
          productId: cartItem.product.id,
          productName: cartItem.product.name,
          quantity: cartItem.quantity,
          price: cartItem.product.price,
        );
      }).toList();

      final sale = Sale(
        items: saleItems,
        totalAmount: _total,
        paymentMethod: 'cash', // Default to cash for now
      );

      await context.read<SalesProvider>().createSale(sale);

      if (mounted) {
        _clearCart();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sale processed successfully!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error processing sale: $e')));
      }
    }
  }

  double get _subtotal => _cart.fold(0, (sum, item) => sum + item.total);
  double get _tax => _subtotal * 0.0825;
  double get _total => _subtotal + _tax;

  @override
  Widget build(BuildContext context) {
    // Ensure dimensions are initialized in case this is the first build
    AppDimensions().init(context);

    return Column(
      children: [
        // Category Tabs
        _buildCategoryTabs(),

        // Product Grid & Cart
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Grid
              Expanded(flex: 3, child: _buildProductGrid()),

              // Cart Panel (Right Side)
              if (AppDimensions.screenWidth >= 1200)
                SizedBox(width: 400, child: _buildCartPanel()),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryTabs() {
    return Consumer<CategoryProvider>(
      builder: (context, categoryProvider, child) {
        final categories = categoryProvider.categories;
        // Reset selected category if it's no longer in the list
        if (_selectedCategoryId != null &&
            !categories.any((c) => c.id == _selectedCategoryId)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _selectedCategoryId = null;
              });
            }
          });
        }

        return Container(
          color: AppConstants.backgroundLight.withValues(
            alpha: 0.95,
          ), // backdrop blur simulated
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // 'All Items' Tab
                _buildTabItem(
                  label: 'All Items',
                  isSelected: _selectedCategoryId == null,
                  onTap: () {
                    setState(() {
                      _selectedCategoryId = null;
                    });
                    context.read<ProductProvider>().fetchProducts();
                  },
                  icon: Icons.grid_view,
                ),

                // Dynamic Categories
                ...categories.map((cat) {
                  return _buildTabItem(
                    label: cat.name,
                    isSelected: _selectedCategoryId == cat.id,
                    onTap: () {
                      setState(() {
                        _selectedCategoryId = cat.id;
                      });
                      context.read<ProductProvider>().fetchProducts(
                        categoryId: cat.id,
                      );
                    },
                    icon: Icons
                        .category, // You could add icons to CategoryModel later
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabItem({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: isSelected ? AppConstants.slate800 : Colors.white,
        borderRadius: BorderRadius.circular(99),
        elevation: isSelected ? 2 : 0,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(99),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: !isSelected
                ? BoxDecoration(
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(99),
                  )
                : null,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 20,
                    color: isSelected ? Colors.white : AppConstants.slate500,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : AppConstants.slate500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return Consumer<ProductProvider>(
      builder: (context, productProvider, child) {
        if (productProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = productProvider.products.where((p) {
          if (_selectedCategoryId == null) return true;
          return p.categoryId == _selectedCategoryId;
        }).toList();

        if (products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  _selectedCategoryId == null
                      ? 'No products available'
                      : 'No products in this category',
                  style: TextStyle(fontSize: 18, color: Colors.grey[500]),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: EdgeInsets.all(AppDimensions.paddingL),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              // Responsive columns based on width
              crossAxisCount: AppDimensions.screenWidth < 900
                  ? 2
                  : AppDimensions.screenWidth < 1200
                  ? 3
                  : 4,
              childAspectRatio: 0.75,
              crossAxisSpacing: AppDimensions.paddingM,
              mainAxisSpacing: AppDimensions.paddingM,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return GestureDetector(
                onTap: () => _addToCart(product),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          width: double.infinity,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child:
                                product.imageUrl != null &&
                                    product.imageUrl!.isNotEmpty
                                ? Image.network(
                                    product.imageUrl!,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Center(
                                              child: Icon(Icons.broken_image),
                                            ),
                                  )
                                : const Center(child: Icon(Icons.image)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Details
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppConstants.slate800,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.details,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppConstants.slate500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstants.primaryColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _addToCart(product),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstants.primaryColor,
                              foregroundColor: Colors.white,
                              shape: const CircleBorder(),
                              padding: const EdgeInsets.all(8),
                              minimumSize: Size.zero,
                            ),
                            child: const Icon(Icons.add, size: 20),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildCartPanel() {
    return Container(
      width: AppDimensions.w(25), // Responsive Cart width
      color: Colors.white,
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Order',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.slate800,
                  ),
                ),
                IconButton(
                  onPressed: _clearCart,
                  icon: const Icon(
                    Icons.delete_sweep,
                    color: AppConstants.slate500,
                  ),
                  tooltip: 'Clear Cart',
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Items
          Expanded(
            child: _cart.isEmpty
                ? const Center(child: Text('Cart is empty'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cart.length,
                    itemBuilder: (context, index) {
                      final item = _cart[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            // Thumbnail
                            Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                color: Colors.grey[100],
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    item.product.imageUrl != null &&
                                        item.product.imageUrl!.isNotEmpty
                                    ? Image.network(
                                        item.product.imageUrl!,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.image),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppConstants.slate800,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    item.product.details,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppConstants.slate500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Price & Controls
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '\$${item.total.toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppConstants.slate800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppConstants.backgroundLight,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    children: [
                                      _qtyButton(
                                        '-',
                                        () => _removeFromCart(item.product),
                                      ),
                                      SizedBox(
                                        width: 24,
                                        child: Text(
                                          '${item.quantity}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      _qtyButton(
                                        '+',
                                        () => _addToCart(item.product),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Summary
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              border: const Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Column(
              children: [
                _summaryRow('Subtotal', '\$${_subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 12),
                _summaryRow('Discount', '- \$0.00', valueColor: Colors.green),
                const SizedBox(height: 12),
                _summaryRow('Tax (8.25%)', '\$${_tax.toStringAsFixed(2)}'),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.slate800,
                      ),
                    ),
                    Text(
                      '\$${_total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.slate800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Action Buttons grid
                Row(
                  children: [
                    Expanded(child: _actionButton(Icons.percent, 'Disc')),
                    const SizedBox(width: 8),
                    Expanded(child: _actionButton(Icons.edit_note, 'Note')),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: _actionButton(
                        Icons.person_add_outlined,
                        'Customer',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 56, // py-4 approx
                  child: ElevatedButton(
                    onPressed: context.watch<SalesProvider>().isLoading
                        ? null
                        : _processCheckout,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      shadowColor: AppConstants.primaryColor.withValues(
                        alpha: 0.4,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          context.watch<SalesProvider>().isLoading
                              ? 'Processing...'
                              : 'Checkout',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (context.watch<SalesProvider>().isLoading)
                          const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        else
                          const Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(String label, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppConstants.slate500,
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: AppConstants.slate500),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppConstants.slate500,
          ),
        ),
      ],
    );
  }

  Widget _actionButton(IconData icon, String label) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 20, color: AppConstants.slate500),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: AppConstants.slate500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
