import 'package:flutter/material.dart';

import '../preferences/auth_preferences.dart';
import '../ui/add_story_screen.dart';
import '../ui/home_screen.dart';
import '../ui/login_screen.dart';
import '../ui/maps_screen.dart';
import '../ui/register_screen.dart';
import '../ui/splash_screen.dart';
import '../ui/story_detail_screen.dart';

// TODO: Ganti jadi pake GoRouter

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

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isAdd = false;
  bool isMaps = false;

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
            onMaps: () {
              isMaps = true;
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
            onMaps: () {
              isMaps = true;
              notifyListeners();
            },
          ),
        ),
        MaterialPage(
          key: const ValueKey("AddStoryScreen"),
          child: AddStoryScreen(
            onHome: () {
              isAdd = false;
              selectedStory = null;
              notifyListeners();
            },
          ),
        ),
      ];
    } else if (isMaps) {
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
            onMaps: () {
              isMaps = true;
              notifyListeners();
            },
          ),
        ),
        MaterialPage(
          key: const ValueKey("MapsScreen"),
          child: MapsScreen(
            onHome: () {
              isMaps = false;
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
            onMaps: () {
              isMaps = true;
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

          isAdd = false;
          isMaps = false;
          isRegister = false;
          selectedStory = null;
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
