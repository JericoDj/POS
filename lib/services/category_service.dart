import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/category_model.dart';

class CategoryService {
  final String baseUrl = 'https://pos-backend-rosy.vercel.app/api/categories';

  Future<List<CategoryModel>> getAllCategories(
    String token, {
    String? businessId,
  }) async {
    final queryParams = <String, String>{};
    if (businessId != null && businessId.isNotEmpty) {
      queryParams['businessId'] = businessId;
    }

    final uri = Uri.parse('$baseUrl/').replace(queryParameters: queryParams);

    print('Fetching categories from: $uri');
    print('Token: ${token.substring(0, 10)}...');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch categories: ${response.body}');
    }
  }

  Future<CategoryModel> createCategory(
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
      return CategoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to create category: ${response.body}');
    }
  }

  Future<CategoryModel> updateCategory(
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
      return CategoryModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update category: ${response.body}');
    }
  }

  Future<void> deleteCategory(String token, String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category: ${response.body}');
    }
  }

  Future<void> bulkDeleteCategories(String token, List<String> ids) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/bulk-delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'ids': ids}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to bulk delete categories: ${response.body}');
    }
  }
}
