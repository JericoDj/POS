import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/product_provider.dart';
import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_dimensions.dart';

class InventorySection extends StatefulWidget {
  const InventorySection({super.key});

  @override
  State<InventorySection> createState() => _InventorySectionState();
}

class _InventorySectionState extends State<InventorySection> {
  @override
  void initState() {
    super.initState();
    // Fetch products when the section is initialized
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

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
            _buildHeaderAction(Icons.category, 'Manage Categories', () {
              _showManageCategoriesDialog(context);
            }),
            const SizedBox(width: 12),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () => _showAddProductDialog(context),
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
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading && provider.products.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                Text(
                  'No products found',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => _showAddProductDialog(context),
                  child: const Text('Add your first product'),
                ),
              ],
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(3), // Product Name & Details
                1: FlexColumnWidth(1), // SKU (Category for now)
                2: FlexColumnWidth(1), // Category
                3: FlexColumnWidth(1), // Price
                4: FlexColumnWidth(1), // Stock
                5: FlexColumnWidth(1), // Status
                6: FixedColumnWidth(50), // Actions
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    border: Border(
                      bottom: BorderSide(color: Colors.grey[200]!),
                    ),
                  ),
                  children: [
                    _buildTableHeader('Product Name'),
                    _buildTableHeader('SKU'), // Placeholder
                    _buildTableHeader('Category'),
                    _buildTableHeader('Price'),
                    _buildTableHeader('Stock'),
                    _buildTableHeader('Status'),
                    const SizedBox(), // Actions column
                  ],
                ),
                // Data Rows
                ...provider.products.map(
                  (product) => TableRow(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey[100]!),
                      ),
                    ),
                    children: [
                      _buildProductCell(product),
                      _buildTextCell(
                        product.id.substring(0, 8).toUpperCase(),
                      ), // Fake SKU
                      _buildTextCell(product.categoryId), // Should map to name
                      _buildTextCell('\$${product.price.toStringAsFixed(2)}'),
                      _buildTextCell('${product.stock}'),
                      _buildStatusCell(product.stock),
                      _buildActionCell(context, product),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTableHeader(String text) {
    return Padding(
      padding: const EdgeInsets.all(16),
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

  Widget _buildTextCell(String text) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, color: AppConstants.slate800),
      ),
    );
  }

  Widget _buildProductCell(Product product) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(6),
              image: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(product.imageUrl!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (product.imageUrl == null || product.imageUrl!.isEmpty)
                ? const Icon(Icons.image, color: Colors.grey, size: 20)
                : null,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: AppConstants.slate800,
                ),
              ),
              if (product.details.isNotEmpty)
                Text(
                  product.details,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppConstants.slate500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCell(int stock) {
    String status = 'In Stock';
    Color color = Colors.green;
    Color bgColor = Colors.green.withOpacity(0.1);

    if (stock == 0) {
      status = 'Out of Stock';
      color = Colors.red;
      bgColor = Colors.red.withOpacity(0.1);
    } else if (stock < 10) {
      status = 'Low Stock';
      color = Colors.orange;
      bgColor = Colors.orange.withOpacity(0.1);
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          status,
          style: TextStyle(
            fontSize: 12,
            color: color,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildActionCell(BuildContext context, Product product) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert, size: 18, color: AppConstants.slate400),
      onSelected: (value) {
        if (value == 'edit') {
          _showAddProductDialog(context, product: product);
        } else if (value == 'delete') {
          _confirmDeleteProduct(context, product);
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'edit', child: Text('Edit')),
        const PopupMenuItem(
          value: 'delete',
          child: Text('Delete', style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  void _confirmDeleteProduct(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Product'),
        content: Text('Are you sure you want to delete "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await Provider.of<ProductProvider>(
                  context,
                  listen: false,
                ).deleteProduct(product.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Product deleted successfully'),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting product: $e')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
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

  void _showAddProductDialog(BuildContext context, {Product? product}) {
    showDialog(
      context: context,
      builder: (context) => ProductDialog(product: product),
    );
  }

  void _showManageCategoriesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const ManageCategoriesDialog(),
    );
  }
}

class ManageCategoriesDialog extends StatefulWidget {
  const ManageCategoriesDialog({super.key});

  @override
  State<ManageCategoriesDialog> createState() => _ManageCategoriesDialogState();
}

class _ManageCategoriesDialogState extends State<ManageCategoriesDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _colorController = TextEditingController(text: '#FF5733');
  bool _isAdding = false;
  CategoryModel? _editingCategory;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _colorController.dispose();
    super.dispose();
  }

  void _resetForm() {
    _nameController.clear();
    _descriptionController.clear();
    _colorController.text = '#FF5733';
    _editingCategory = null;
    setState(() {
      _isAdding = false;
    });
  }

  void _populateForm(CategoryModel category) {
    _nameController.text = category.name;
    _descriptionController.text = category.description;
    _colorController.text = category.color;
    _editingCategory = category;
    setState(() {
      _isAdding = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 600,
        height: 700,
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Manage Categories',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.slate800,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(height: 32),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // List of Categories
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            _resetForm();
                            setState(() {
                              _isAdding = true;
                            });
                          },
                          icon: const Icon(Icons.add),
                          label: const Text('Add New Category'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 48),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: Consumer<CategoryProvider>(
                            builder: (context, provider, child) {
                              if (provider.isLoading &&
                                  provider.categories.isEmpty) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (provider.categories.isEmpty) {
                                return const Center(
                                  child: Text('No categories found'),
                                );
                              }

                              return ListView.separated(
                                itemCount: provider.categories.length,
                                separatorBuilder: (ctx, idx) =>
                                    const Divider(height: 1),
                                itemBuilder: (context, index) {
                                  final category = provider.categories[index];
                                  final isSelected =
                                      _editingCategory?.id == category.id;
                                  return ListTile(
                                    selected: isSelected,
                                    selectedTileColor: AppConstants.primaryColor
                                        .withOpacity(0.1),
                                    leading: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: _parseColor(category.color),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    title: Text(
                                      category.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: isSelected
                                            ? AppConstants.primaryColor
                                            : AppConstants.slate800,
                                      ),
                                    ),
                                    subtitle: Text(
                                      category.description,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                          color: AppConstants.slate500,
                                          onPressed: () =>
                                              _populateForm(category),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 20,
                                          ),
                                          color: Colors.red,
                                          onPressed: () => _confirmDelete(
                                            context,
                                            provider,
                                            category,
                                          ),
                                        ),
                                      ],
                                    ),
                                    onTap: () => _populateForm(category),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const VerticalDivider(width: 48),
                  // Form
                  Expanded(
                    flex: 1,
                    child: _isAdding
                        ? Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _editingCategory == null
                                      ? 'Create Category'
                                      : 'Edit Category',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                TextFormField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    labelText: 'Category Name',
                                    border: OutlineInputBorder(),
                                  ),
                                  validator: (value) =>
                                      value == null || value.isEmpty
                                      ? 'Required'
                                      : null,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _descriptionController,
                                  decoration: const InputDecoration(
                                    labelText: 'Description',
                                    border: OutlineInputBorder(),
                                  ),
                                  maxLines: 3,
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: _colorController,
                                  decoration: InputDecoration(
                                    labelText: 'Color Hex (e.g. #FF5733)',
                                    border: const OutlineInputBorder(),
                                    suffixIcon: Container(
                                      margin: const EdgeInsets.all(8),
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: _parseColor(
                                          _colorController.text,
                                        ),
                                        shape: BoxShape.circle,
                                        border: Border.all(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  onChanged: (_) => setState(() {}),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    OutlinedButton(
                                      onPressed: _resetForm,
                                      child: const Text('Cancel'),
                                    ),
                                    const SizedBox(width: 16),
                                    Consumer<CategoryProvider>(
                                      builder: (context, provider, child) {
                                        return ElevatedButton(
                                          onPressed: provider.isLoading
                                              ? null
                                              : () => _submitForm(provider),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                AppConstants.primaryColor,
                                            foregroundColor: Colors.white,
                                          ),
                                          child: provider.isLoading
                                              ? const SizedBox(
                                                  width: 20,
                                                  height: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        color: Colors.white,
                                                      ),
                                                )
                                              : Text(
                                                  _editingCategory == null
                                                      ? 'Create'
                                                      : 'Update',
                                                ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.category_outlined,
                                  size: 64,
                                  color: Colors.grey[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Select a category to edit\nor create a new one',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Colors.grey[500]),
                                ),
                              ],
                            ),
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

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xff')));
    } catch (e) {
      return Colors.grey;
    }
  }

  Future<void> _submitForm(CategoryProvider provider) async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        'color': _colorController.text,
      };

      try {
        if (_editingCategory == null) {
          await provider.createCategory(data);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Category created successfully')),
            );
            _resetForm();
          }
        } else {
          await provider.updateCategory(_editingCategory!.id, data);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Category updated successfully')),
            );
            _resetForm();
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }
    }
  }

  void _confirmDelete(
    BuildContext context,
    CategoryProvider provider,
    CategoryModel category,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Are you sure you want to delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              try {
                await provider.deleteCategory(category.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Category deleted')),
                  );
                  if (_editingCategory?.id == category.id) {
                    _resetForm();
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Error deleting: $e')));
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

class ProductDialog extends StatefulWidget {
  final Product? product;

  const ProductDialog({super.key, this.product});

  @override
  State<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends State<ProductDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late TextEditingController _detailsController;
  late TextEditingController _imageUrlController;
  String? _selectedCategoryId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Verify token is available before fetching
    final productProvider = Provider.of<ProductProvider>(
      context,
      listen: false,
    );
    productProvider.fetchProducts();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _stockController = TextEditingController(
      text: widget.product?.stock.toString() ?? '',
    );
    _detailsController = TextEditingController(
      text: widget.product?.details ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.product?.imageUrl ?? '',
    );
    _selectedCategoryId = widget.product?.categoryId;

    // Fetch categories if not already loaded (to populate dropdown)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    _detailsController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        final productProvider = Provider.of<ProductProvider>(
          context,
          listen: false,
        );
        final data = {
          'name': _nameController.text,
          'price': double.tryParse(_priceController.text) ?? 0.0,
          'stock': int.tryParse(_stockController.text) ?? 0,
          'details': _detailsController.text,
          'imageUrl': _imageUrlController.text,
          'categoryId': _selectedCategoryId ?? '',
        };

        if (widget.product == null) {
          await productProvider.addProduct(data);
        } else {
          await productProvider.updateProduct(widget.product!.id, data);
        }

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                widget.product == null ? 'Product added' : 'Product updated',
              ),
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error saving product: $e')));
        }
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.product == null ? 'Add Product' : 'Edit Product',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.slate800,
                ),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  return DropdownButtonFormField<String>(
                    value: _selectedCategoryId,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categoryProvider.categories.map((category) {
                      return DropdownMenuItem(
                        value: category.id,
                        child: Text(category.name),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCategoryId = value),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Required' : null,
                  );
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        labelText: 'Price',
                        border: OutlineInputBorder(),
                        prefixText: '\$ ',
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _stockController,
                      decoration: const InputDecoration(
                        labelText: 'Stock',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (Optional)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(
                  labelText: 'Description / Details',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveProduct,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstants.primaryColor,
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            widget.product == null
                                ? 'Add Product'
                                : 'Save Changes',
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
