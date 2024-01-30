import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/login_responses.dart';
import '../model/register_responses.dart';

class ApiService {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';

  static Future<RegisterResponse> register(String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return RegisterResponse.fromJson(jsonDecode(response.body));
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception(responseBody['message'] ?? 'Failed to register user');
    }
  }

  static Future<LoginResponse> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception(responseBody['message'] ?? 'Failed to login');
    }
  }
}