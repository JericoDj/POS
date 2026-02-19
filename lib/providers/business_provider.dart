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
        fetchAllBusinesses(_token!);
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
      final businesses = await _businessService.getBusinessProfile(token);
      _businesses = businesses;

      if (_businesses.isNotEmpty) {
        // If current business is null or not in the new list, select the first one
        if (_currentBusiness == null ||
            !_businesses.any((b) => b.id == _currentBusiness!.id)) {
          _currentBusiness = _businesses.first;
        } else {
          // Update current business with fresh data
          _currentBusiness = _businesses.firstWhere(
            (b) => b.id == _currentBusiness!.id,
          );
        }
        await _box.write('current_business', _currentBusiness!.toJson());
      } else {
        _currentBusiness = null;
        await _box.remove('current_business');
      }

      await _box.write(
        'all_businesses',
        _businesses.map((e) => e.toJson()).toList(),
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

  Future<void> createBusiness(String token, Map<String, dynamic> data) async {
    try {
      _isLoading = true;
      notifyListeners();

      final business = await _businessService.createBusiness(token, data);
      _currentBusiness = business;
      await _box.write('current_business', business.toJson());
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
      await fetchAllBusinesses(token);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteBusiness(String token, String id) async {
    try {
      _isLoading = true;
      notifyListeners();

      await _businessService.deleteBusiness(token, id);
      await fetchAllBusinesses(token);

      if (_currentBusiness?.id == id) {
        if (_businesses.isNotEmpty) {
          await switchBusiness(_businesses.first);
        } else {
          await clearBusiness();
        }
      }
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

  Future<void> updateCurrentBusinessSubscription(
    Map<String, dynamic> subscriptionData,
  ) async {
    if (_token == null || _currentBusiness == null) return;
    try {
      await _businessService.subscribeBusiness(
        _token!,
        _currentBusiness!.id,
        subscriptionData,
      );
      // Refresh business data to get the latest status
      await fetchAllBusinesses(_token!);
    } catch (e) {
      print('Error updating subscription: $e');
      rethrow;
    }
  }

  void updateSubscriptionLocally(Map<String, dynamic> subscriptionData) {
    if (_currentBusiness != null) {
      final updatedBusinessData = _currentBusiness!.toJson();
      updatedBusinessData['subscription'] = subscriptionData;

      _currentBusiness = BusinessModel.fromJson(updatedBusinessData);
      _box.write('current_business', _currentBusiness!.toJson());
      notifyListeners();
    }
  }
}
