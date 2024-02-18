import 'package:json_annotation/json_annotation.dart';
import 'package:storyio/data/model/user.dart';

part 'login_responses.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool error;
  final String message;
  final User loginResult;

  LoginResponse(
      {required this.error, required this.message, required this.loginResult});

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}
