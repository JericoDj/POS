import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';

class CustomersSection extends StatelessWidget {
  const CustomersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            const Text(
              'No customer data available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppConstants.slate500,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Customer management feature is coming soon.',
              style: TextStyle(color: AppConstants.slate400),
            ),
          ],
        ),
      ),
    );
  }
}
