import 'dart:convert';

class User {
  final String userId;
  final String name;
  final String token;

  User({required this.userId, required this.name, required this.token});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      name: json['name'],
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'token': token,
    };
  }
}

User userFromJson(String jsonString) {
  final jsonData = json.decode(jsonString);
  return User.fromJson(jsonData);
}

String userToJson(User user) {
  final jsonData = user.toJson();
  return json.encode(jsonData);
}
