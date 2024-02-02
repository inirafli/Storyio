import 'package:storyio/data/model/story.dart';

class StoriesResponse {
  final bool error;
  final String message;
  final List<Story> listStory;

  StoriesResponse({
    required this.error,
    required this.message,
    required this.listStory,
  });

  factory StoriesResponse.fromJson(Map<String, dynamic> json) {
    return StoriesResponse(
      error: json['error'],
      message: json['message'],
      listStory: (json['listStory'] as List<dynamic>)
          .map((story) => Story.fromJson(story))
          .toList(),
    );
  }
}
