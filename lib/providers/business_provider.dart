import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import '../models/business_model.dart';
import '../services/business_service.dart';

class BusinessProvider extends ChangeNotifier {
  final BusinessService _businessService = BusinessService();
  final _box = GetStorage();

  BusinessModel? _currentBusiness;
  List<BusinessModel> _businesses = [];
  bool _isLoading = false;
  String? _token;

  BusinessModel? get currentBusiness => _currentBusiness;
  List<BusinessModel> get businesses => _businesses;
  bool get isLoading => _isLoading;

  BusinessProvider() {
    _loadFromStorage();
  }

  void update(String? token) {
    if (_token != token) {
      _token = token;
      if (_token != null) {
        // Fetch all businesses and current profile
        fetchAllBusinesses(_token!);
        fetchBusinessProfile(_token!);
      } else {
        clearBusiness();
      }
    }
  }

  void _loadFromStorage() {
    final data = _box.read('current_business');
    if (data != null) {
      try {
        _currentBusiness = BusinessModel.fromJson(data);
      } catch (e) {
        print('Error parsing stored business data: $e');
        _box.remove('current_business');
      }
    }

    final businessesData = _box.read('all_businesses');
    if (businessesData != null && businessesData is List) {
      try {
        _businesses = businessesData
            .map((e) => BusinessModel.fromJson(e))
            .toList();
      } catch (e) {
        print('Error parsing stored businesses list: $e');
        _box.remove('all_businesses');
      }
    }
    notifyListeners();
  }

  Future<void> fetchAllBusinesses(String token) async {
    try {
      // Don't set global loading here to avoid blocking UI if it's a background fetch
      // or set separate loading state if needed. For now, we'll just notify listeners when done.
      final businesses = await _businessService.getAllBusinesses(token);
      _businesses = businesses;
      await _box.write(
        'all_businesses',
        businesses.map((e) => e.toJson()).toList(),
      );
      notifyListeners();
    } catch (e) {
      print('Error fetching businesses: $e');
    }
  }

  Future<void> switchBusiness(BusinessModel business) async {
    _currentBusiness = business;
    await _box.write('current_business', business.toJson());
    notifyListeners();
  }

  Future<void> fetchBusinessProfile(String token) async {
    try {
      _isLoading = true;
      notifyListeners();

      // If we already have a selected business from storage, we might want to refresh it
      // or if we have none, we might want to select the first one from the list or fetch specific profile.
      // For now, keep existing behavior of fetching specific profile if endpoint exists,
      // but typically "getBusinessProfile" implies getting *the* business for single-tenant
      // or *a* default business.
      // If the backend returns the "active" business context, that's good.
      // If we are moving to multi-business, we might need to be careful here.
      // Let's assume fetchBusinessProfile returns the last active or default business.

      final business = await _businessService.getBusinessProfile(token);
      _currentBusiness = business;
      await _box.write('current_business', business.toJson());
    } catch (e) {
      print('Error fetching business profile: $e');
      // If fetch fails (e.g. 404), it might mean no business exists yet.
      // We shouldn't rethrow if we want the UI to handle "no business" state gracefully.
      // rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createBusiness(String token, Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      notifyListeners();

      final business = await _businessService.createBusiness(token, data);
      _currentBusiness = business;
      await _box.write('current_business', business.toJson());
      // Refresh the list of businesses
      await fetchAllBusinesses(token);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateBusiness(
    String token,
    String id,
    Map<String, dynamic> data,
  ) async {
    try {
      _isLoading = true;
      notifyListeners();

      final business = await _businessService.updateBusiness(token, id, data);
      _currentBusiness = business;
      await _box.write('current_business', business.toJson());
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> clearBusiness() async {
    _currentBusiness = null;
    _businesses = [];
    await _box.remove('current_business');
    await _box.remove('all_businesses');
    notifyListeners();
  }
}
