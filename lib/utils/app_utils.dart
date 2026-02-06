class AppUtils {
  // Add static helper methods here
  static String formatCurrency(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}
