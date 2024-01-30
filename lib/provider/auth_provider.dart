import 'package:flutter/material.dart';

import '../data/model/user.dart';
import '../data/api/api_services.dart';
import '../preferences/auth_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;

  User? get currentUser => _currentUser;
  String? errorMessage;

  Future<void> registerUser(String name, String email, String password) async {
    try {
      final response = await ApiService.register(name, email, password);
      if (!response.error) {
        notifyListeners();
      } else {
        errorMessage = _sanitizeErrorMessage(response.message);
      }
    } catch (e) {
      errorMessage = 'Registration failed, ${_sanitizeErrorMessage(e.toString())}';
      throw Exception('Registration failed, $e');
    }
  }

  Future<void> loginUser(String email, String password) async {
    try {
      final response = await ApiService.login(email, password);
      if (!response.error) {
        _currentUser = response.loginResult;
        await AuthPreferences.saveUserData(_currentUser!);
        notifyListeners();
      } else {
        errorMessage = _sanitizeErrorMessage(response.message);
        throw Exception(response.message);
      }
    } catch (e) {
      errorMessage = 'Login failed, ${_sanitizeErrorMessage(e.toString())}';
      throw Exception('Login failed, $e');
    }
  }

  Future<void> logoutUser() async {
    await AuthPreferences.clearUserData();
    _currentUser = null;
    errorMessage = null;
    notifyListeners();
  }

  String _sanitizeErrorMessage(String message) {
    return message.replaceFirst(RegExp(r'^Exception: '), '');
  }
}