import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/business_provider.dart';
import '../../providers/auth_provider.dart';
import '../../constants/app_constants.dart';
import '../../models/business_model.dart';
import '../../widgets/dialog_text_field.dart';

class ManageOrganizationsScreen extends StatefulWidget {
  const ManageOrganizationsScreen({super.key});

  @override
  State<ManageOrganizationsScreen> createState() =>
      _ManageOrganizationsScreenState();
}

class _ManageOrganizationsScreenState extends State<ManageOrganizationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final businessProvider = Provider.of<BusinessProvider>(
        context,
        listen: false,
      );
      if (authProvider.token != null) {
        businessProvider.fetchAllBusinesses(authProvider.token!);
      }
    });
  }

  void _showCreateDialog() {
    final nameController = TextEditingController();
    final addressController = TextEditingController();
    final contactController = TextEditingController();
    String selectedType = 'Retail';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New Organization'),
        content: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DialogTextField(
                  controller: nameController,
                  label: 'Business Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DialogTextField(
                  controller: addressController,
                  label: 'Address',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DialogTextField(
                  controller: contactController,
                  label: 'Contact Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Business Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Retail', 'Restaurant', 'Service', 'Other']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) selectedType = value;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final businessProvider = Provider.of<BusinessProvider>(
                  context,
                  listen: false,
                );

                final data = {
                  'name': nameController.text,
                  'address': addressController.text,
                  'contact': contactController.text,
                  'type': selectedType,
                };

                try {
                  await businessProvider.createBusiness(
                    authProvider.token!,
                    data,
                  );
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error: ${e.toString().replaceAll('Exception: ', '')}',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BusinessModel business) {
    final nameController = TextEditingController(text: business.name);
    final addressController = TextEditingController(text: business.address);
    final contactController = TextEditingController(text: business.contact);
    String selectedType = business.type.isNotEmpty ? business.type : 'Retail';
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Organization'),
        content: SizedBox(
          width: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DialogTextField(
                  controller: nameController,
                  label: 'Business Name',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DialogTextField(
                  controller: addressController,
                  label: 'Address',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an address';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DialogTextField(
                  controller: contactController,
                  label: 'Contact Number',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a contact number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Business Type',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Retail', 'Restaurant', 'Service', 'Other']
                      .map(
                        (type) =>
                            DropdownMenuItem(value: type, child: Text(type)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value != null) selectedType = value;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final authProvider = Provider.of<AuthProvider>(
                  context,
                  listen: false,
                );
                final businessProvider = Provider.of<BusinessProvider>(
                  context,
                  listen: false,
                );

                final data = {
                  'name': nameController.text,
                  'address': addressController.text,
                  'contact': contactController.text,
                  'type': selectedType,
                };

                try {
                  await businessProvider.updateBusiness(
                    authProvider.token!,
                    business.id,
                    data,
                  );
                  if (context.mounted) Navigator.pop(context);
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Error: ${e.toString().replaceAll('Exception: ', '')}',
                        ),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BusinessModel business) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Organization'),
        content: Text(
          'Are you sure you want to delete "${business.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () async {
              final authProvider = Provider.of<AuthProvider>(
                context,
                listen: false,
              );
              final businessProvider = Provider.of<BusinessProvider>(
                context,
                listen: false,
              );

              try {
                await businessProvider.deleteBusiness(
                  authProvider.token!,
                  business.id,
                );
                if (context.mounted) Navigator.pop(context);
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Error: ${e.toString().replaceAll('Exception: ', '')}',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<BusinessProvider>(context);
    final businesses = businessProvider.businesses;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Organizations'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: _showCreateDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('New Organization'),
            ),
          ),
        ],
      ),
      body: businessProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : businesses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No organizations yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppConstants.slate500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create your first organization to get started.',
                    style: TextStyle(color: AppConstants.slate400),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _showCreateDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('New Organization'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: businesses.length,
              itemBuilder: (context, index) {
                final business = businesses[index];
                final isCurrent =
                    business.id == businessProvider.currentBusiness?.id;

                return Card(
                  elevation: isCurrent ? 2 : 1,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: isCurrent
                        ? BorderSide(color: AppConstants.primaryColor, width: 2)
                        : BorderSide.none,
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppConstants.primaryColor
                            : const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        business.name.isNotEmpty
                            ? business.name[0].toUpperCase()
                            : '?',
                        style: TextStyle(
                          color: isCurrent
                              ? Colors.white
                              : const Color(0xFF475569),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            business.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        if (isCurrent)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppConstants.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'ACTIVE',
                              style: TextStyle(
                                color: AppConstants.primaryColor,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        '${business.type} · ${business.address}',
                        style: const TextStyle(
                          color: AppConstants.slate500,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isCurrent)
                          TextButton(
                            onPressed: () {
                              businessProvider.switchBusiness(business);
                            },
                            child: const Text('Switch'),
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () => _showEditDialog(business),
                          tooltip: 'Edit',
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                          onPressed: () => _showDeleteConfirmation(business),
                          tooltip: 'Delete',
                        ),
                      ],
                    ),
                    onTap: isCurrent
                        ? null
                        : () => businessProvider.switchBusiness(business),
                  ),
                );
              },
            ),
    );
  }
}
