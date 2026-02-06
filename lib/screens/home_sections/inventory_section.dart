import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_dimensions.dart';

class InventorySection extends StatefulWidget {
  const InventorySection({super.key});

  @override
  State<InventorySection> createState() => _InventorySectionState();
}

class _InventorySectionState extends State<InventorySection> {
  // Mock Data
  final List<Map<String, dynamic>> _inventoryItems = [
    {
      'id': '1',
      'name': 'Latte',
      'sku': 'COF-001',
      'category': 'Coffee',
      'price': 4.50,
      'status': 'In Stock', // In Stock, Low Stock, Out of Stock
      'quantity': 120,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB54cQc2xWbL8kgums124aAIxX6L6aXvezO6vtQYh2waJKtCuEvXYVPa9gApMxN7CaQLBsVCEoBoU1mrpfK3sQHHCsyXvWBcxE7urt-_Rkdh9cCk_axjZOQQ-Vy80Z34J3onQr9nJNWs3ChkSbPWi0a8dIq0H-GWIccbO1t5W4-1PvUejG5k83L7oT6nyMzZ2RskyXq7LxJk86__g5L7fWwvIJx_RfqLZlJWMlwd7YKTyVlzzB9TnNj7eyTDVxyYQdbWPuB-y4ikhF0',
    },
    {
      'id': '2',
      'name': 'Croissant',
      'sku': 'PAS-002',
      'category': 'Pastries',
      'price': 3.00,
      'status': 'Low Stock',
      'quantity': 8,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDbV-kJAd_e4lKSiE8k1sLh6wNE2dcNZHW1J65o5oqyxbgUfRNTAA4dmoH_6EUsT_v0vqn3VLfWmbduwE9QdkprkOMkm2UvGGlcv0jl5anM03zh0_tz-Lgoq3cz2dWKMeXZ1lS6Iz3OaFjrZtEBUoAILQgEYPqdL0ecvOf5MpU8cwhry2fMAK0uVtggcfLqGUdPNC6y2JrkKYNLCOaWwrK1LBJvOsWW8xC-MOoELbZ1jA_pHf6djxma43dB6yNiBWQIds0RAaWUSD_D',
    },
    {
      'id': '3',
      'name': 'Avo Toast',
      'sku': 'FOD-003',
      'category': 'Food',
      'price': 8.50,
      'status': 'In Stock',
      'quantity': 45,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB3t6HO50eZ5DknwfJ07_i-CTPtixU1lbz3gvfd7a6wmLCUGjI9PsdxIzELL_cx5M6snDgSY0ooILafUW6dN4sB6F2fwS7dvgWo0ob3V5zGtg44N1HzOZNVLwZpd2yJ_IEQi5-7FfZfuRC9nOvz_S-Bms-oaxfxeNredBlNQd4uj1KjLmbVfnPLFnx4nAhR09FEQ86SLsfZM4fVW09vN6oh4Jj-_5DVtDk-tOwKLpoDxh6fvu27d9SnBZghjypAg8wILTOFZ8qh66iL',
    },
    {
      'id': '4',
      'name': 'Cappuccino',
      'sku': 'COF-004',
      'category': 'Coffee',
      'price': 4.00,
      'status': 'Out of Stock',
      'quantity': 0,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDJVxmscgRdaxnF6ExRbhoS53RMyGUuKkwIbg79FJ92rfhP1ODpMyfzo7MxWp2P8sX6t4Z5i2U1mo_BG7Txpuhq5wPg5gnzInMpJKCZgV3KLuCzVGgC7MLSUg9OLcs7b6FumR5JUNRAMxII585A9hWjrlsr_zU4cDZTTJFxWpYRN4PVfZ6utAg5pTJT5ha1hjBG8bKSsiqP5jV3KqoUgcOPEwFjl11u0njjHwDCKTow3dDqHmIhJwNEQPn5BTR7vsKXpRFkWb2W4Qcr',
    },
    {
      'id': '5',
      'name': 'Iced Tea',
      'sku': 'DRK-005',
      'category': 'Drinks',
      'price': 3.50,
      'status': 'In Stock',
      'quantity': 85,
      'image':
          'https://lh3.googleusercontent.com/aida-public/AB6AXuALDTfdD88u7Oq6zIOMD8-BzS1exSdVVlR7rP_AgsYRktH_TOzNu6iJy0EzAHsXgumv3FHJ4v3U9or7u8Zklux3TVtlsduLOblfEUAe2qT4oOdmHhFjCDd7y60EYYFUYxG0JjQlZoTBp1JerC8tjrlg2H2enwh8JaCVPFfzGDgw-OOaQ39XxNEn-zILBCl2Sjx1dXt3aBwpoP_nusfeUDE6acOxqwa1wuS6YyzbIvOFBoSrCtxABU_a014zWW9vn3-cvDfmWvaJP0gQ',
    },
  ];

  @override
  Widget build(BuildContext context) {
    AppDimensions().init(context);

    return Container(
      color: AppConstants.backgroundLight,
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildToolbar(),
          const SizedBox(height: 16),
          Expanded(child: _buildInventoryTable()),
          const SizedBox(height: 16),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Inventory Management',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppConstants.slate800,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Manage your products, stock levels, and pricing',
              style: TextStyle(fontSize: 14, color: AppConstants.slate500),
            ),
          ],
        ),
        Row(
          children: [
            _buildHeaderAction(Icons.download, 'Export', () {}),
            const SizedBox(width: 12),
            _buildHeaderAction(Icons.category, 'Manage Categories', () {}),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Product'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderAction(IconData icon, String label, VoidCallback onTap) {
    return OutlinedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 18, color: AppConstants.slate800),
      label: Text(label, style: const TextStyle(color: AppConstants.slate800)),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        side: BorderSide(color: Colors.grey[300]!),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          // Search
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: AppConstants.backgroundLight,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by product name, SKU, or category...',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: AppConstants.slate500,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppConstants.slate500,
                    size: 20,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.only(bottom: 8),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Filter
          OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(
              Icons.filter_list,
              size: 18,
              color: AppConstants.slate800,
            ),
            label: const Text(
              'Filters',
              style: TextStyle(color: AppConstants.slate800),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ), // taller to match search height
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // View Toggle
          Container(
            decoration: BoxDecoration(
              color: AppConstants.backgroundLight,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                _buildViewToggle(Icons.table_chart, true),
                Container(width: 1, height: 24, color: Colors.grey[300]),
                _buildViewToggle(Icons.grid_view, false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildViewToggle(IconData icon, bool isSelected) {
    return InkWell(
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          size: 20,
          color: isSelected ? AppConstants.primaryColor : AppConstants.slate500,
        ),
      ),
    );
  }

  Widget _buildInventoryTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Row(
              children: [
                _buildColHeader('Product Name', 3),
                _buildColHeader('SKU', 2),
                _buildColHeader('Category', 2),
                _buildColHeader('Price', 1),
                _buildColHeader('Stock Status', 2),
                _buildColHeader('Qty', 1),
                const SizedBox(width: 48), // Action space
              ],
            ),
          ),
          // List
          Expanded(
            child: ListView.separated(
              itemCount: _inventoryItems.length,
              separatorBuilder: (ctx, index) =>
                  const Divider(height: 1, indent: 24, endIndent: 24),
              itemBuilder: (context, index) {
                final item = _inventoryItems[index];
                return _buildTableRow(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColHeader(String text, int flex) {
    return Expanded(
      flex: flex,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppConstants.slate500,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      item['image'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.broken_image, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  item['name'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppConstants.slate800,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item['sku'],
              style: const TextStyle(color: AppConstants.slate500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              item['category'],
              style: const TextStyle(color: AppConstants.slate500),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '\$${item['price'].toStringAsFixed(2)}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppConstants.slate800,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Row(children: [_buildStatusBadge(item['status'])]),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${item['quantity']}',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppConstants.slate800,
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert, color: AppConstants.slate500),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color bg;
    Color text;
    if (status == 'In Stock') {
      bg = Colors.green.withValues(alpha: 0.1);
      text = Colors.green;
    } else if (status == 'Low Stock') {
      bg = Colors.amber.withValues(alpha: 0.1);
      text = Colors.amber[800]!;
    } else {
      bg = Colors.red.withValues(alpha: 0.1);
      text = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: text,
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Showing 1-10 of 97 products',
          style: TextStyle(color: AppConstants.slate500, fontSize: 14),
        ),
        Row(
          children: [
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Previous',
                style: TextStyle(color: AppConstants.slate800),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppConstants.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                '1',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Text(
                '2',
                style: TextStyle(
                  color: AppConstants.slate800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Text(
                '...',
                style: TextStyle(color: AppConstants.slate500),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Text(
                '10',
                style: TextStyle(
                  color: AppConstants.slate800,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey[300]!),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(color: AppConstants.slate800),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
