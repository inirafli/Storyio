import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../common/result_state.dart';
import '../data/api/api_services.dart';
import '../data/model/story.dart';

class StoryProvider with ChangeNotifier {
  List<Story> _storyList = [];
  ResultState _storyListState = ResultState.done;
  ResultState _storyDetailState = ResultState.done;
  ResultState _addStoryState = ResultState.done;

  int? pageItems = 1;
  int sizeItems = 10;

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
    if (pageItems == 1) {
      _storyListState = ResultState.loading;
      notifyListeners();
    }

    try {
      final response = await ApiService.getAllStories(token,
          page: pageItems, size: sizeItems, location: location);

      if (!response.error) {
        _storyListErrorMessage = null;

        if (pageItems == 1) {
          _storyList = response.listStory;
        } else {
          _storyList.addAll(response.listStory);
        }

        if (response.listStory.length < sizeItems) {
          pageItems = null;
        } else {
          pageItems = pageItems! + 1;
        }

        _storyListState = ResultState.done;
        notifyListeners();
      } else {
        _storyListErrorMessage = response.message;
        _storyListState = ResultState.error;
        notifyListeners();
      }
    } catch (e) {
      if (e is SocketException) {
        _storyListErrorMessage =
            'No internet connection. Please check your network settings.';
      } else {
        _storyListErrorMessage =
            'Failed to fetch Stories, ${_sanitizeErrorMessage(e.toString())}';
      }

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
      if (e is SocketException) {
        _storyDetailErrorMessage =
            'No internet connection. Please check your network settings.';
      } else {
        _storyDetailErrorMessage =
            'Failed to fetch Story Detail, ${_sanitizeErrorMessage(e.toString())}';
      }

      _storyDetailState = ResultState.error;
      notifyListeners();
    }
  }

  Future<void> addNewStory(String token, String description, File photo,
      {LatLng? location,}) async {
    _addStoryState = ResultState.loading;
    notifyListeners();

    try {
      final response = await ApiService.addNewStory(token, description, photo,
          lat: location?.latitude, lon: location?.longitude);

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
      if (e is SocketException) {
        _addStoryErrorMessage =
            'No internet connection. Please check your network settings.';
      } else {
        _addStoryErrorMessage =
            'Failed to add new story, ${_sanitizeErrorMessage(e.toString())}';
      }

      _addStoryState = ResultState.error;
      notifyListeners();
    }
  }

  String _sanitizeErrorMessage(String message) {
    return message.replaceFirst(RegExp(r'^Exception: '), '');
  }
}
