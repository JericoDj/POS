import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_dimensions.dart';
import 'package:provider/provider.dart';
import '../../providers/sales_provider.dart';
import '../../models/sale_model.dart';
import 'package:intl/intl.dart';

class SalesHistorySection extends StatefulWidget {
  const SalesHistorySection({super.key});

  @override
  State<SalesHistorySection> createState() => _SalesHistorySectionState();
}

class _SalesHistorySectionState extends State<SalesHistorySection> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SalesProvider>().fetchSalesHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: Consumer<SalesProvider>(
              builder: (context, salesProvider, child) {
                if (salesProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (salesProvider.sales.isEmpty) {
                  return _buildEmptyState();
                }

                return _buildSalesList(salesProvider.sales);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Sales History',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppConstants.slate800,
          ),
        ),
        IconButton(
          onPressed: () {
            context.read<SalesProvider>().fetchSalesHistory();
          },
          icon: const Icon(Icons.refresh, color: AppConstants.slate500),
          tooltip: 'Refresh',
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'No sales history available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppConstants.slate500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Transactions will appear here once processed.',
            style: TextStyle(color: AppConstants.slate400),
          ),
        ],
      ),
    );
  }

  Widget _buildSalesList(List<Sale> sales) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      color: Colors.white,
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: sales.length,
        separatorBuilder: (context, index) => const Divider(),
        itemBuilder: (context, index) {
          final sale = sales[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: AppConstants.primaryColor.withOpacity(0.1),
              child: const Icon(
                Icons.receipt_long,
                color: AppConstants.primaryColor,
                size: 20,
              ),
            ),
            title: Text(
              'Sale #${sale.id != null ? sale.id!.substring(0, 8) : '...'}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppConstants.slate800,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sale.createdAt != null
                      ? DateFormat('MMM d, y • h:mm a').format(sale.createdAt!)
                      : 'Just now',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppConstants.slate500,
                  ),
                ),
                if (sale.status != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(sale.status!).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        sale.status!.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getStatusColor(sale.status!),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${sale.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppConstants.slate800,
                      ),
                    ),
                    Text(
                      '${sale.items.length} items • ${sale.paymentMethod}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppConstants.slate500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      _showEditDialog(context, sale);
                    } else if (value == 'delete') {
                      _deleteSale(context, sale.id!);
                    }
                  },
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                        const PopupMenuItem<String>(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(
                                Icons.edit,
                                size: 18,
                                color: AppConstants.slate800,
                              ),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        const PopupMenuItem<String>(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: Colors.red),
                              SizedBox(width: 8),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ],
                  icon: const Icon(
                    Icons.more_vert,
                    color: AppConstants.slate500,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'refunded':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return AppConstants.primaryColor;
    }
  }

  void _showEditDialog(BuildContext context, Sale sale) {
    String status = sale.status ?? 'completed';
    String paymentMethod = sale.paymentMethod;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Sale'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: ['completed', 'refunded', 'pending']
                  .map(
                    (s) => DropdownMenuItem(
                      value: s,
                      child: Text(s.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) => status = value!,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: paymentMethod,
              decoration: const InputDecoration(labelText: 'Payment Method'),
              items: ['cash', 'card', 'qr_code']
                  .map(
                    (m) => DropdownMenuItem(
                      value: m,
                      child: Text(m.toUpperCase()),
                    ),
                  )
                  .toList(),
              onChanged: (value) => paymentMethod = value!,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<SalesProvider>().updateSale(sale.id!, {
                  'status': status,
                  'paymentMethod': paymentMethod,
                });
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sale updated successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error updating sale: $e')),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteSale(BuildContext context, String saleId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Sale'),
        content: const Text(
          'Are you sure you want to delete this sale? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              Navigator.pop(context);
              try {
                await context.read<SalesProvider>().deleteSale(saleId);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sale deleted successfully')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error deleting sale: $e')),
                  );
                }
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
