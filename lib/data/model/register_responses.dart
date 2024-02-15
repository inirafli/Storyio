import 'package:json_annotation/json_annotation.dart';

part 'register_responses.g.dart';

@JsonSerializable()
class RegisterResponse {
  final bool error;
  final String message;

  RegisterResponse({required this.error, required this.message});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}
