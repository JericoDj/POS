import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_dimensions.dart';
import '../../models/product_model.dart';
import '../../models/cart_model.dart';

class SalesSection extends StatefulWidget {
  const SalesSection({super.key});

  @override
  State<SalesSection> createState() => _SalesSectionState();
}

class _SalesSectionState extends State<SalesSection> {
  // Mock Data
  final List<Product> _products = [
    const Product(
      id: '1',
      name: 'Latte',
      category: 'Coffee',
      price: 4.50,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB54cQc2xWbL8kgums124aAIxX6L6aXvezO6vtQYh2waJKtCuEvXYVPa9gApMxN7CaQLBsVCEoBoU1mrpfK3sQHHCsyXvWBcxE7urt-_Rkdh9cCk_axjZOQQ-Vy80Z34J3onQr9nJNWs3ChkSbPWi0a8dIq0H-GWIccbO1t5W4-1PvUejG5k83L7oT6nyMzZ2RskyXq7LxJk86__g5L7fWwvIJx_RfqLZlJWMlwd7YKTyVlzzB9TnNj7eyTDVxyYQdbWPuB-y4ikhF0',
      description: '12 oz',
    ),
    const Product(
      id: '2',
      name: 'Croissant',
      category: 'Pastries',
      price: 3.00,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDbV-kJAd_e4lKSiE8k1sLh6wNE2dcNZHW1J65o5oqyxbgUfRNTAA4dmoH_6EUsT_v0vqn3VLfWmbduwE9QdkprkOMkm2UvGGlcv0jl5anM03zh0_tz-Lgoq3cz2dWKMeXZ1lS6Iz3OaFjrZtEBUoAILQgEYPqdL0ecvOf5MpU8cwhry2fMAK0uVtggcfLqGUdPNC6y2JrkKYNLCOaWwrK1LBJvOsWW8xC-MOoELbZ1jA_pHf6djxma43dB6yNiBWQIds0RAaWUSD_D',
      description: 'Butter',
    ),
    const Product(
      id: '3',
      name: 'Avo Toast',
      category: 'Food',
      price: 8.50,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB3t6HO50eZ5DknwfJ07_i-CTPtixU1lbz3gvfd7a6wmLCUGjI9PsdxIzELL_cx5M6snDgSY0ooILafUW6dN4sB6F2fwS7dvgWo0ob3V5zGtg44N1HzOZNVLwZpd2yJ_IEQi5-7FfZfuRC9nOvz_S-Bms-oaxfxeNredBlNQd4uj1KjLmbVfnPLFnx4nAhR09FEQ86SLsfZM4fVW09vN6oh4Jj-_5DVtDk-tOwKLpoDxh6fvu27d9SnBZghjypAg8wILTOFZ8qh66iL',
      description: 'Sourdough',
    ),
    const Product(
      id: '4',
      name: 'Cappuccino',
      category: 'Coffee',
      price: 4.00,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDJVxmscgRdaxnF6ExRbhoS53RMyGUuKkwIbg79FJ92rfhP1ODpMyfzo7MxWp2P8sX6t4Z5i2U1mo_BG7Txpuhq5wPg5gnzInMpJKCZgV3KLuCzVGgC7MLSUg9OLcs7b6FumR5JUNRAMxII585A9hWjrlsr_zU4cDZTTJFxWpYRN4PVfZ6utAg5pTJT5ha1hjBG8bKSsiqP5jV3KqoUgcOPEwFjl11u0njjHwDCKTow3dDqHmIhJwNEQPn5BTR7vsKXpRFkWb2W4Qcr',
      description: '8 oz',
    ),
    const Product(
      id: '5',
      name: 'Bagel',
      category: 'Pastries',
      price: 2.50,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDgds_uWxxJsPQ-f3yQdVLCtd8hxogqbUM7F25S5IUWUL4ZLsVKOPd6856D_ortsbLlspSZs6vKFF9gkDyYdKEyxR2yZvgrqGSwNpkrR42HOxND-Dd-Wn-A08pCtXn4fqOwZA5LBS2O9B0F3HUur3735sNrEqjwTuw_0Yw_QSGFIHapmLkDoI3ylKAVuxbDeiMDCWNmYgmNqsOESuWRUJXsc4PGCvA5qvE7TFH61EZOGT__yNU55R4kWTnw_ANQR5zjJYW_uBIAmgyR',
      description: 'Plain',
    ),
    const Product(
      id: '6',
      name: 'Iced Tea',
      category: 'Drinks',
      price: 3.50,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuALDTfdD88u7Oq6zIOMD8-BzS1exSdVVlR7rP_AgsYRktH_TOzNu6iJy0EzAHsXgumv3FHJ4v3U9or7u8Zklux3TVtlsduLOblfEUAe2qT4oOdmHhFjCDd7y60EYYFUYxG0JjQlZoTBp1JerC8tjrlg2H2enwh8JaCVPFfzGDgw-OOaQ39XxNEn-zILBCl2Sjx1dXt3aBwpoP_nusfeUDE6acOxqwa1wuS6YyzbIvOFBoSrCtxABU_a014zWW9vn3-cvDfmWvaJP0gQ',
      description: 'Lemon',
    ),
    const Product(
      id: '7',
      name: 'Muffin',
      category: 'Pastries',
      price: 3.25,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDoBjl7ewK7HZ0MXCicfeJWe0ThksxPDCa1O1piM210IYgvSd3PNEh5M_so5676c7UZ3w-IHUTlnSftCdLxstmXbQtbNNp0NDW1NC4eT_IEAurviOHo4BpCbq7P6uTX7uODagWlXSwRK1m8bzuZd5wtfWg72MorN8uqlTNV_ZyaNFcwV06JPWGaBPnCIi4WYrRnNct55iM0LRn9ebveUlCGOQZRlhYgO5UeOFtdAx-kXY8nBn6R4zn54XjYEvXrc_P6k9_m3rLKYbEx',
      description: 'Blueberry',
    ),
    const Product(
      id: '8',
      name: 'Espresso',
      category: 'Coffee',
      price: 2.75,
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD3RYR95IF8QGFwgV6GZVgKZCJLAIHnXbGcpHRaVt_PZAGvIGeivO-Ly4jbWcgSJFFtCOR_5oniDenB31X1p7guAqxynzKdOvDifSy0ZZ2HbKcCQmR8RTrpA-1cWD4Ro7MuefNmiLDI3igVqwWsFIYcKRRP9flxZKPrd-gBuA4t89quaKtiaO2J0iKj9niPDLLKEjZHR0QJvUEuUjlHkj_-QgZ85xcZC4Un5VjhAyvPot522v0THWnwKDntF8dSJRLw6ljzyo8ebaLS',
      description: 'Double',
    ),
  ];

  final List<CartItem> _cart = [];

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
    final categories = [
      'All Items',
      'Coffee',
      'Pastries',
      'Sandwiches',
      'Merch',
      'Favorites',
    ];

    return Container(
      color: AppConstants.backgroundLight.withValues(
        alpha: 0.95,
      ), // backdrop blur simulated
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((cat) {
            final isSelected = cat == 'All Items';
            return Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Material(
                color: isSelected ? AppConstants.slate800 : Colors.white,
                borderRadius: BorderRadius.circular(99),
                elevation: isSelected ? 2 : 0,
                child: InkWell(
                  onTap: () {},
                  borderRadius: BorderRadius.circular(99),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: !isSelected
                        ? BoxDecoration(
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(99),
                          )
                        : null,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Icon mapping
                        Icon(
                          _getCategoryIcon(cat),
                          size: 20,
                          color: isSelected
                              ? Colors.white
                              : AppConstants.slate500,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          cat,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? Colors.white
                                : AppConstants.slate500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'All Items':
        return Icons.grid_view;
      case 'Coffee':
        return Icons.coffee;
      case 'Pastries':
        return Icons.bakery_dining;
      case 'Sandwiches':
        return Icons.lunch_dining;
      case 'Merch':
        return Icons.shopping_bag;
      case 'Favorites':
        return Icons.favorite;
      default:
        return Icons.category;
    }
  }

  Widget _buildProductGrid() {
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
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
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
                        child: Image.network(
                          product.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.broken_image)),
                        ),
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
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        product.description,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppConstants.slate500,
                        ),
                      ),
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
                ],
              ),
            ),
          );
        },
      ),
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
            child: ListView.builder(
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
                          child: Image.network(
                            item.product.imageUrl,
                            fit: BoxFit.cover,
                          ),
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
                              item.product.description,
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
                                _qtyButton('+', () => _addToCart(item.product)),
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
                    onPressed: () {},
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
                      children: const [
                        Text(
                          'Checkout',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(Icons.arrow_forward),
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
