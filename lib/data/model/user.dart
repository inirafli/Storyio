import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String userId;
  final String name;
  final String token;

  User({required this.userId, required this.name, required this.token});

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

}

User userFromJson(String jsonString) {
  final jsonData = json.decode(jsonString);
  return User.fromJson(jsonData);
}

String userToJson(User user) {
  final jsonData = user.toJson();
  return json.encode(jsonData);
}
