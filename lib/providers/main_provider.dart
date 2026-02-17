import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class MainProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  String? _token;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  MainProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    if (_token != null) {
      try {
        _isLoading = true;
        notifyListeners();
        _user = await _authService.getCurrentUser(_token!);
      } catch (e) {
        _token = null;
        await prefs.remove('auth_token');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }

  Future<void> login(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      final data = await _authService.login(email, password);
      _token = data['idToken'];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', _token!);
      _user = await _authService.getCurrentUser(_token!);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String email,
    required String password,
    String? displayName,
    String? role,
    String? businessId,
    String? phoneNumber,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();
      // Register returns the user model directly based on my implementation
      // Use the returned user or fetch it if needed.
      // Based on AuthService implementation it returns UserModel
      // But it doesn't return the token unless the API does.
      // If API registers but doesn't login automatically, we might need to login.
      // Assuming register creates user but we need to login to get token?
      // Re-reading AuthService login: returns token.
      // Re-reading AuthService register: returns UserModel.
      // Typically register either returns token or we must separate login.
      // Let's assume for now we call register then login for better flow if API doesn't return token.

      await _authService.register(
        email: email,
        password: password,
        displayName: displayName,
        role: role ?? 'staff',
        businessId: businessId,
      );

      // Auto login after register
      await login(email, password);

      // If phone number is provided, update the user profile
      if (phoneNumber != null && phoneNumber.isNotEmpty && _token != null) {
        await _authService.updateUser(_token!, {'phoneNumber': phoneNumber});
        // Refresh user data
        _user = await _authService.getCurrentUser(_token!);
      }
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshUser() async {
    if (_token != null) {
      try {
        _user = await _authService.getCurrentUser(_token!);
        notifyListeners();
      } catch (e) {
        print('Error refreshing user: $e');
      }
    }
  }

  Future<void> logout() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    notifyListeners();
  }

  Future<void> forgotPassword(String email) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _authService.forgotPassword(email);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUser(Map<String, dynamic> data) async {
    if (_token == null) return;
    try {
      _isLoading = true;
      notifyListeners();
      _user = await _authService.updateUser(_token!, data);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteAccount() async {
    if (_token == null) return;
    try {
      _isLoading = true;
      notifyListeners();
      await _authService.deleteAccount(_token!);
      await logout();
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
