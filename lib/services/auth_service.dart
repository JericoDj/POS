import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://pos-backend-rosy.vercel.app/api/auth';

  Future<UserModel> register({
    required String email,
    required String password,
    String? displayName,
    String role = 'staff',
    String? businessId,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
        'displayName': displayName,
        'role': role,
        'businessId': businessId,
      }),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Depending on API response structure, adjust this.
      // Assuming register returns user object or message.
      // If it doesn't return user object, we might need to login or just return null/void.
      // Based on common practices, let's assume it returns the created user or we login after.
      // For now, let's return a UserModel constructed from input or response if available.
      return UserModel.fromJson(data['user'] ?? data);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> refreshToken(String refreshToken) async {
    final response = await http.post(
      Uri.parse('$baseUrl/refresh-token'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send password reset email: ${response.body}');
    }
  }

  Future<UserModel> getCurrentUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to get current user: ${response.body}');
    }
  }

  Future<UserModel> updateUser(String token, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      jsonDecode(response.body);
      // Re-fetch or update local model.
      // Assuming response contains updated user or just success message.
      // It's safer to re-fetch or if API returns updated user use that.
      // Let's assume it returns user.
      return UserModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  Future<void> deleteAccount(String token) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete account: ${response.body}');
    }
  }
}
