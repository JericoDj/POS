import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<CategoryModel> _categories = [];
  bool _isLoading = false;
  String? _token;
  String? _businessId;

  List<CategoryModel> get categories => _categories;
  bool get isLoading => _isLoading;

  void update(String? token, String? businessId) {
    final bool shouldFetch = _token != token || _businessId != businessId;
    _token = token;
    _businessId = businessId;

    if (_token != null && _businessId != null) {
      if (shouldFetch) {
        _categories = [];
        notifyListeners();
      }
      if (shouldFetch || _categories.isEmpty) {
        fetchCategories();
      }
    } else {
      _categories = [];
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    if (_token == null) return;
    try {
      _isLoading = true;
      // notifyListeners(); // Avoid notifying here to prevent build issues during init

      _categories = await _categoryService.getAllCategories(
        _token!,
        businessId: _businessId,
      );
    } catch (e) {
      print('Error fetching categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createCategory(Map<String, dynamic> data) async {
    if (_token == null) return;
    try {
      _isLoading = true;
      notifyListeners();

      final categoryData = {...data, 'businessId': _businessId};
      await _categoryService.createCategory(_token!, categoryData);
      await fetchCategories();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    if (_token == null) return;
    try {
      _isLoading = true;
      notifyListeners();

      await _categoryService.updateCategory(_token!, id, data);
      await fetchCategories();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCategory(String id) async {
    if (_token == null) return;
    try {
      _isLoading = true;
      notifyListeners();

      await _categoryService.deleteCategory(_token!, id);
      await fetchCategories();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> bulkDeleteCategories(List<String> ids) async {
    if (_token == null) return;
    try {
      _isLoading = true;
      notifyListeners();

      await _categoryService.bulkDeleteCategories(_token!, ids);
      await fetchCategories();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
