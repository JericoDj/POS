import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sale_model.dart';

class SalesService {
  final String baseUrl = 'https://pos-backend-rosy.vercel.app/api/sales';

  Future<Sale> createSale(String token, Sale sale) async {
    final response = await http.post(
      Uri.parse('$baseUrl/'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        if (sale.businessId != null) 'X-Business-Id': sale.businessId!,
      },
      body: jsonEncode(sale.toJson()),
    );

    if (response.statusCode == 201) {
      return Sale.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('401 Unauthorized: ${response.body}');
    } else {
      throw Exception('Failed to create sale: ${response.body}');
    }
  }

  Future<List<Sale>> getSalesHistory(
    String token, {
    String? businessId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final queryParams = <String, String>{};
    if (businessId != null) queryParams['businessId'] = businessId;
    if (startDate != null) {
      queryParams['startDate'] = startDate.toIso8601String().split('T')[0];
    }
    if (endDate != null) {
      queryParams['endDate'] = endDate.toIso8601String().split('T')[0];
    }

    final uri = Uri.parse('$baseUrl/').replace(queryParameters: queryParams);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
        if (businessId != null) 'X-Business-Id': businessId,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Sale.fromJson(json)).toList();
    } else if (response.statusCode == 401) {
      throw Exception('401 Unauthorized: ${response.body}');
    } else {
      throw Exception('Failed to fetch sales history: ${response.body}');
    }
  }

  Future<Sale> getSaleById(String token, String id) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return Sale.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('401 Unauthorized: ${response.body}');
    } else {
      throw Exception('Failed to fetch sale: ${response.body}');
    }
  }

  Future<Sale> updateSale(
    String token,
    String id,
    Map<String, dynamic> updates,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(updates),
    );

    if (response.statusCode == 200) {
      return Sale.fromJson(jsonDecode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('401 Unauthorized: ${response.body}');
    } else {
      throw Exception('Failed to update sale: ${response.body}');
    }
  }

  Future<void> deleteSale(String token, String id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return;
    } else if (response.statusCode == 401) {
      throw Exception('401 Unauthorized: ${response.body}');
    } else {
      throw Exception('Failed to delete sale: ${response.body}');
    }
  }
}
