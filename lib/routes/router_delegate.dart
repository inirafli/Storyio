import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../preferences/auth_preferences.dart';
import '../ui/add_story_screen.dart';
import '../ui/home_screen.dart';
import '../ui/login_screen.dart';
import '../ui/maps_screen.dart';
import '../ui/register_screen.dart';
import '../ui/splash_screen.dart';
import '../ui/story_detail_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthPreferences authPreferences;

  MyRouterDelegate(
    this.authPreferences,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    isLoggedIn = await authPreferences.isLoggedIn();
    notifyListeners();
  }

  String? selectedStory;
  LatLng? selectedLocation;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isAdd = false;
  bool isMap = false;

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashPage"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  List<Page> get _loggedInStack {
    if (selectedStory != null) {
      return [
        MaterialPage(
          key: const ValueKey("HomeScreen"),
          child: HomeScreen(
            onStoryTap: (storyId) {
              selectedStory = storyId;
              isAdd = false;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              isAdd = false;
              selectedStory = null;
              notifyListeners();
            },
            onAdd: () {
              isAdd = true;
              notifyListeners();
            },
          ),
        ),
        MaterialPage(
          key: ValueKey(selectedStory),
          child: StoryDetailScreen(
            storyId: selectedStory!,
            onHome: () {
              selectedStory = null;
              notifyListeners();
            },
          ),
        ),
      ];
    } else if (isAdd) {
      return [
        MaterialPage(
          key: const ValueKey("HomeScreen"),
          child: HomeScreen(
            onStoryTap: (storyId) {
              selectedStory = storyId;
              isAdd = false;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              isAdd = false;
              notifyListeners();
            },
            onAdd: () {
              isAdd = true;
              notifyListeners();
            },
          ),
        ),
        MaterialPage(
          key: const ValueKey("AddStoryScreen"),
          child: AddStoryScreen(
            onHome: () {
              isAdd = false;
              isMap = false;
              selectedStory = null;
              selectedLocation = null;
              notifyListeners();
            },
            onLocation: () {
              isMap = true;
              notifyListeners();
            },
            selectedLocation: selectedLocation,
            updateSelectedLocation: (LatLng? location) {
              selectedLocation = location;
              notifyListeners();
            },
          ),
        ),
        if (isMap)
          MaterialPage(
            key: const ValueKey("MapsScreen"),
            child: MapsScreen(
              onBack: () {
                isAdd = true;
                isMap = false;
                notifyListeners();
              },
              onLocationPicked: (LatLng location) {
                isAdd = true;
                isMap = false;
                selectedLocation = location;
                notifyListeners();
              },
            ),
          ),
      ];
    } else {
      return [
        MaterialPage(
          key: const ValueKey("HomeScreen"),
          child: HomeScreen(
            onStoryTap: (storyId) {
              selectedStory = storyId;
              isAdd = false;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              isAdd = false;
              notifyListeners();
            },
            onAdd: () {
              isAdd = true;
              notifyListeners();
            },
          ),
        ),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }

    return Navigator(
        key: navigatorKey,
        pages: historyStack,
        onPopPage: (route, result) {
          final didPop = route.didPop(result);
          if (!didPop) {
            return false;
          }

          if (isMap) {
            isAdd = true;
            isMap = false;
            selectedLocation = null;
          } else {
            isAdd = false;
          }

          isRegister = false;
          selectedStory = null;
          selectedLocation = null;
          notifyListeners();

          return true;
        });
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}
