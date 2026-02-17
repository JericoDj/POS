import 'package:flutter/material.dart';
import '../models/sale_model.dart';
import '../services/sales_service.dart';

class SalesProvider with ChangeNotifier {
  final SalesService _salesService = SalesService();
  List<Sale> _sales = [];
  bool _isLoading = false;
  String? _authToken;
  String? _businessId;

  List<Sale> get sales => _sales;
  bool get isLoading => _isLoading;

  void update(String? token, String? businessId) {
    _authToken = token;
    _businessId = businessId;
    notifyListeners();
  }

  Future<void> fetchSalesHistory({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (_authToken == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      _sales = await _salesService.getSalesHistory(
        _authToken!,
        businessId: _businessId,
        startDate: startDate,
        endDate: endDate,
      );
    } catch (e) {
      print('Error fetching sales history: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createSale(Sale sale) async {
    if (_authToken == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      // Ensure businessId is set if not already
      final saleToCreate = Sale(
        items: sale.items,
        totalAmount: sale.totalAmount,
        paymentMethod: sale.paymentMethod,
        businessId: sale.businessId ?? _businessId,
      );

      final newSale = await _salesService.createSale(_authToken!, saleToCreate);
      _sales.insert(0, newSale); // Add to top of list
      notifyListeners();
    } catch (e) {
      print('Error creating sale: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSale(String id, Map<String, dynamic> updates) async {
    if (_authToken == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final updatedSale = await _salesService.updateSale(
        _authToken!,
        id,
        updates,
      );
      final index = _sales.indexWhere((s) => s.id == id);
      if (index != -1) {
        _sales[index] = updatedSale;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating sale: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSale(String id) async {
    if (_authToken == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      await _salesService.deleteSale(_authToken!, id);
      _sales.removeWhere((s) => s.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting sale: $e');
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
