import 'package:flutter/material.dart';
import 'auth_provider.dart';
import '../models/product_model.dart';
import '../services/product_service.dart';

class ProductProvider extends ChangeNotifier {
  final ProductService _productService = ProductService();

  List<Product> _products = [];
  bool _isLoading = false;
  AuthProvider? _authProvider;
  String? _businessId;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  void update(AuthProvider authProvider, String? businessId) {
    final bool businessChanged = _businessId != businessId;
    _authProvider = authProvider;
    _businessId = businessId;

    if (_authProvider?.token != null && _businessId != null) {
      if (businessChanged) {
        _products = [];
        notifyListeners();
      }
      if (businessChanged || _products.isEmpty) {
        fetchProducts();
      }
    } else {
      _products = [];
      notifyListeners();
    }
  }

  Future<void> _performAuthenticatedAction(
    Future<void> Function(String token) action,
  ) async {
    if (_authProvider?.token == null) return;
    try {
      await action(_authProvider!.token!);
    } catch (e) {
      if (e.toString().contains('401') ||
          e.toString().contains('Unauthorized')) {
        try {
          await _authProvider!.refreshAccessToken();
          if (_authProvider?.token != null) {
            await action(_authProvider!.token!);
          }
        } catch (refreshError) {
          rethrow;
        }
      } else {
        rethrow;
      }
    }
  }

  Future<void> fetchProducts({String? categoryId}) async {
    if (_authProvider?.token == null) return;
    await _performAuthenticatedAction((token) async {
      try {
        _isLoading = true;
        // notifyListeners(); // Avoid triggering build during init

        if (categoryId != null && categoryId.isNotEmpty) {
          _products = await _productService.getProductsByCategory(
            token,
            categoryId: categoryId,
            limit: 1000,
          );
        } else {
          var productsList = await _productService.getAllProducts(
            token,
            categoryId: categoryId,
            businessId: _businessId,
          );

          // Client-side filtering as safeguard
          if (_businessId != null && _businessId!.isNotEmpty) {
            productsList = productsList.where((p) {
              // Keep if businessId matches OR if product has no businessId (legacy/fallback)
              // If backend returns products from other businesses, they should have a different businessId
              return p.businessId == null || p.businessId == _businessId;
            }).toList();
          }
          _products = productsList;
        }
      } catch (e) {
        print('Error fetching products: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> addProduct(Map<String, dynamic> data) async {
    await _performAuthenticatedAction((token) async {
      _isLoading = true;
      notifyListeners();

      try {
        final productData = {...data, 'businessId': _businessId};
        await _productService.createProduct(token, productData);
        await fetchProducts();
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _performAuthenticatedAction((token) async {
      try {
        _isLoading = true;
        notifyListeners();

        await _productService.updateProduct(token, id, data);
        await fetchProducts();
      } catch (e) {
        rethrow;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> deleteProduct(String id) async {
    await _performAuthenticatedAction((token) async {
      try {
        _isLoading = true;
        notifyListeners();

        await _productService.deleteProduct(token, id);
        await fetchProducts();
      } catch (e) {
        rethrow;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }

  Future<void> bulkDelete(List<String> ids) async {
    await _performAuthenticatedAction((token) async {
      try {
        _isLoading = true;
        notifyListeners();

        await _productService.bulkDeleteProducts(token, ids);
        await fetchProducts();
      } catch (e) {
        rethrow;
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }
}
