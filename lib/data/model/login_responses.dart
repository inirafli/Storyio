import 'package:storyio/data/model/user.dart';

class LoginResponse {
  final bool error;
  final String message;
  final User loginResult;

  LoginResponse(
      {required this.error, required this.message, required this.loginResult});

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      error: json['error'],
      message: json['message'],
      loginResult: User.fromJson(json['loginResult']),
    );
  }
}
