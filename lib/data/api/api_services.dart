import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../model/add_story_response.dart';
import '../model/login_responses.dart';
import '../model/register_responses.dart';
import '../model/stories_response.dart';
import '../model/story_detail_response.dart';

class ApiService {
  static const String baseUrl = 'https://story-api.dicoding.dev/v1';

  static Future<RegisterResponse> register(
      String name, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
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

    if (response.statusCode == 200 || response.statusCode == 201) {
      return LoginResponse.fromJson(jsonDecode(response.body));
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception(responseBody['message'] ?? 'Failed to login');
    }
  }

  static Future<StoriesResponse> getAllStories(String token,
      {int? page, int? size, int? location}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stories'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return StoriesResponse.fromJson(jsonDecode(response.body));
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception(responseBody['message'] ?? 'Failed to fetch stories');
    }
  }

  static Future<StoryDetailResponse> getStoryDetail(
      String token, String storyId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/stories/$storyId'),
      headers: {
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return StoryDetailResponse.fromJson(jsonDecode(response.body));
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception(
          responseBody['message'] ?? 'Failed to fetch story detail');
    }
  }

  static Future<AddStoryResponse> addNewStory(
      String token, String description, File photo,
      {double? lat, double? lon}) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/stories'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['description'] = description;
    request.fields['lat'] = lat?.toString() ?? '0.0';
    request.fields['lon'] = lon?.toString() ?? '0.0';

    final fileStream = http.ByteStream(photo.openRead());
    final length = await photo.length();

    request.files.add(http.MultipartFile(
      'photo',
      fileStream,
      length,
      filename: photo.path.split('/').last,
    ));

    final response = await http.Response.fromStream(await request.send());

    if (response.statusCode == 200) {
      return AddStoryResponse.fromJson(jsonDecode(response.body));
    } else {
      final responseBody = jsonDecode(response.body);
      throw Exception(responseBody['message'] ?? 'Failed to add new story');
    }
  }
}
