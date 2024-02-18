import 'package:shared_preferences/shared_preferences.dart';

import '../data/model/user.dart';

class AuthPreferences {
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _keyUserData = 'userData';

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final loggedIn = prefs.getBool(_keyIsLoggedIn) ?? false;
    return loggedIn;
  }

  static Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, true);
    await prefs.setString(_keyUserData, userToJson(user));
  }

  static Future<User> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString(_keyUserData);
    if (userDataString != null && userDataString.isNotEmpty) {
      final user = userFromJson(userDataString);
      return user;
    } else {
      // Return a default User or handle it based on your use case
      return User(userId: '', name: '', token: '');
    }
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
    await prefs.remove(_keyUserData);
  }
}