import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  String? _token;
  String? _refreshToken;
  bool _isLoading = false;

  UserModel? get user => _user;
  String? get token => _token;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _token != null;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
    _refreshToken = prefs.getString('refresh_token');

    if (_token != null) {
      try {
        _isLoading = true;
        notifyListeners();
        _user = await _authService.getCurrentUser(_token!);
      } catch (e) {
        // If getting user fails, try refreshing token
        if (_refreshToken != null) {
          try {
            await refreshAccessToken();
            // User fetching is handled inside refreshAccessToken or we retry here?
            // refreshAccessToken updates _token.
            // Let's retry fetching user.
            _user = await _authService.getCurrentUser(_token!);
          } catch (refreshError) {
            _token = null;
            _refreshToken = null;
            await prefs.remove('auth_token');
            await prefs.remove('refresh_token');
          }
        } else {
          _token = null;
          await prefs.remove('auth_token');
        }
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
      _refreshToken = data['refreshToken']; // Assuming key is refreshToken

      final prefs = await SharedPreferences.getInstance();
      if (_token != null) await prefs.setString('auth_token', _token!);
      if (_refreshToken != null)
        await prefs.setString('refresh_token', _refreshToken!);

      _user = await _authService.getCurrentUser(_token!);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshAccessToken() async {
    if (_refreshToken == null) {
      throw Exception('No refresh token available');
    }
    try {
      final data = await _authService.refreshToken(_refreshToken!);
      _token =
          data['id_token']; // Firebase usually returns 'id_token' and 'refresh_token'
      _refreshToken = data['refresh_token'];

      final prefs = await SharedPreferences.getInstance();
      if (_token != null) await prefs.setString('auth_token', _token!);
      if (_refreshToken != null)
        await prefs.setString('refresh_token', _refreshToken!);

      notifyListeners();
    } catch (e) {
      // If refresh fails, log out
      await logout();
      rethrow;
    }
  }

  // Registration logic remains similar but we might need to handle auto-login return types if modified.
  // For now leaving register as is, but it calls login() which is updated.

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
      // Register logic...
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
    _refreshToken = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('refresh_token');
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
