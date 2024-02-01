import 'package:flutter/material.dart';

import '../common/result_state.dart';
import '../data/model/user.dart';
import '../data/api/api_services.dart';
import '../preferences/auth_preferences.dart';

class AuthProvider with ChangeNotifier {
  User? _currentUser;
  ResultState _registerState = ResultState.done;
  ResultState _loginState = ResultState.done;

  User? get currentUser => _currentUser;
  ResultState get registerState => _registerState;
  ResultState get loginState => _loginState;
  String? errorMessage;

  Future<void> registerUser(String name, String email, String password) async {
    print('RegisterUser: registerUser called!');
    _registerState = ResultState.loading;
    notifyListeners();

    try {
      final response = await ApiService.register(name, email, password);

      if (!response.error) {
        errorMessage = null;
        _registerState = ResultState.done;
        notifyListeners();
      } else {
        errorMessage = _sanitizeErrorMessage(response.message);
        _registerState = ResultState.error;
        notifyListeners();
      }
    } catch (e) {
      errorMessage = 'Registration failed, ${_sanitizeErrorMessage(e.toString())}';
      _registerState = ResultState.error;
      notifyListeners();
      print(errorMessage);
    }
  }

  Future<void> loginUser(String email, String password) async {
    print('LoginUser: loginUser called!');
    _loginState = ResultState.loading;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);
      print('Login Response: $response');

      if (!response.error) {
        _currentUser = response.loginResult;
        await AuthPreferences.saveUserData(_currentUser!);
        _loginState = ResultState.done;
        notifyListeners();
      } else {
        errorMessage = _sanitizeErrorMessage(response.message);
        _loginState = ResultState.error;
        notifyListeners();
        print(errorMessage);
      }
    } catch (e) {
      errorMessage = 'Login failed, ${_sanitizeErrorMessage(e.toString())}';
      _loginState = ResultState.error;
      notifyListeners();
      print(errorMessage);
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