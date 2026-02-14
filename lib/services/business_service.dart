import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/business_model.dart';

class BusinessService {
  final String baseUrl = 'https://pos-backend-rosy.vercel.app/api/business';

  Future<BusinessModel> createBusiness(
    String token,
    Map<String, dynamic> data,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return BusinessModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create business: ${response.body}');
    }
  }

  Future<BusinessModel> getBusinessProfile(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return BusinessModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch business profile: ${response.body}');
    }
  }

  Future<BusinessModel> updateBusiness(
    String token,
    String id,
    Map<String, dynamic> data,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return BusinessModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update business: ${response.body}');
    }
  }

  Future<void> deleteBusiness(String token, String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete business: ${response.body}');
    }
  }

  Future<List<BusinessModel>> getAllBusinesses(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => BusinessModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch businesses: ${response.body}');
    }
  }
}
