import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class UserService {
  final String baseUrl = '${AppConstants.backendUrl}/users';

  Future<void> updateSubscriptionId(String token, String subscriptionId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/subscription'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'subscriptionId': subscriptionId}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('Failed to update user subscription: ${response.body}');
    }
  }
}
