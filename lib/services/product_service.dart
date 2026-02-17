import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductService {
  final String baseUrl = 'https://pos-backend-rosy.vercel.app/api/products';

  Future<List<Product>> getProductsByCategory(
    String token, {
    required String categoryId,
    int limit = 20,
    List<String>? excludedIds,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/category'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'categoryId': categoryId,
        'limit': limit,
        if (excludedIds != null) 'excludedIds': excludedIds,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('401 Unauthorized: ${response.body}');
    } else {
      throw Exception('Failed to fetch products by category: ${response.body}');
    }
  }

  Future<List<Product>> getAllProducts(
    String token, {
    String? categoryId,
    String? businessId,
  }) async {
    final queryParams = <String, String>{};
    if (categoryId != null && categoryId.isNotEmpty) {
      queryParams['categoryId'] = categoryId;
    }
    if (businessId != null && businessId.isNotEmpty) {
      queryParams['businessId'] = businessId;
    }

    // Ensure trailing slash for consistency
    final uri = Uri.parse('$baseUrl/').replace(queryParameters: queryParams);

    print('Fetching products from: $uri');

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      if (data.isNotEmpty) {
        // Debug log to check if businessId is returned
        print(
          'First product debug: ID=${data[0]['id']}, BusinessID=${data[0]['businessId']}',
        );
      }
      return data.map((json) => Product.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('401 Unauthorized: ${response.body}');
    } else {
      throw Exception('Failed to fetch products: ${response.body}');
    }
  }

  Future<Product> getProductById(String token, String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Product.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('401 Unauthorized: ${response.body}');
    } else {
      throw Exception('Failed to fetch product: ${response.body}');
    }
  }

  Future<Product> createProduct(String token, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 201) {
      return Product.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 403) {
      throw Exception('Product limit reached. Please upgrade your plan.');
    } else if (response.statusCode == 401) {
      throw Exception('401 Unauthorized: ${response.body}');
    } else {
      throw Exception('Failed to create product: ${response.body}');
    }
  }

  Future<Product> updateProduct(
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
      return Product.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('401 Unauthorized: ${response.body}');
    } else {
      throw Exception('Failed to update product: ${response.body}');
    }
  }

  Future<void> deleteProduct(String token, String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception('401 Unauthorized: ${response.body}');
      }
      throw Exception('Failed to delete product: ${response.body}');
    }
  }

  Future<void> bulkDeleteProducts(String token, List<String> ids) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/bulk-delete'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'ids': ids}),
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 401) {
        throw Exception('401 Unauthorized: ${response.body}');
      }
      throw Exception('Failed to bulk delete products: ${response.body}');
    }
  }
}
