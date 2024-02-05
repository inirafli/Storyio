import 'dart:io';

import 'package:flutter/material.dart';

import '../common/result_state.dart';
import '../data/api/api_services.dart';
import '../data/model/story.dart';

class StoryProvider with ChangeNotifier {
  List<Story> _storyList = [];
  ResultState _storyListState = ResultState.done;
  ResultState _storyDetailState = ResultState.done;
  ResultState _addStoryState = ResultState.done;
  String? _storyListErrorMessage;
  String? _addStoryErrorMessage;
  String? _storyDetailErrorMessage;

  List<Story> get storyList => _storyList;

  ResultState get storyListState => _storyListState;

  ResultState get storyDetailState => _storyDetailState;

  ResultState get addStoryState => _addStoryState;

  String? get storyListErrorMessage => _storyListErrorMessage;

  String? get addStoryErrorMessage => _addStoryErrorMessage;

  String? get storyDetailErrorMessage => _storyDetailErrorMessage;

  Future<void> getAllStories(String token,
      {int? page, int? size, int? location}) async {
    _storyListState = ResultState.loading;
    notifyListeners();

    try {
      final response = await ApiService.getAllStories(token,
          page: page, size: size, location: location);

      if (!response.error) {
        _storyListErrorMessage = null;
        _storyList = response.listStory;
        _storyListState = ResultState.done;
        notifyListeners();
      } else {
        _storyListErrorMessage = response.message;
        _storyListState = ResultState.error;
        notifyListeners();
      }
    } catch (e) {
      _storyListErrorMessage =
          'Failed to fetch Stories, ${_sanitizeErrorMessage(e.toString())}';
      _storyListState = ResultState.error;
      notifyListeners();
    }
  }

  Future<void> getStoryDetail(String token, String storyId) async {
    _storyDetailState = ResultState.loading;
    notifyListeners();

    try {
      final response = await ApiService.getStoryDetail(token, storyId);

      if (!response.error) {
        _storyDetailErrorMessage = null;
        _storyDetailState = ResultState.done;
        notifyListeners();
      } else {
        _storyDetailErrorMessage = response.message;
        _storyDetailState = ResultState.error;
        notifyListeners();
      }
    } catch (e) {
      _storyDetailErrorMessage =
          'Failed to fetch Story Detail, ${_sanitizeErrorMessage(e.toString())}';
      _storyDetailState = ResultState.error;
      notifyListeners();
    }
  }

  Future<void> addNewStory(String token, String description, File photo,
      {double? lat, double? lon}) async {
    _addStoryState = ResultState.loading;
    notifyListeners();

    try {
      final response = await ApiService.addNewStory(token, description, photo,
          lat: lat, lon: lon);

      if (!response.error) {
        _addStoryErrorMessage = null;
        _addStoryState = ResultState.done;
        notifyListeners();
      } else {
        _addStoryErrorMessage = response.message;
        _addStoryState = ResultState.error;
        notifyListeners();
      }
    } catch (e) {
      _addStoryErrorMessage =
          'Failed to add new story, ${_sanitizeErrorMessage(e.toString())}';
      _addStoryState = ResultState.error;
      notifyListeners();
    }
  }

  String _sanitizeErrorMessage(String message) {
    return message.replaceFirst(RegExp(r'^Exception: '), '');
  }
}
