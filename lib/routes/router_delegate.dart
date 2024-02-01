import 'package:flutter/material.dart';
import 'package:storyio/preferences/auth_preferences.dart';
import 'package:storyio/ui/home_screen.dart';

import '../ui/login_screen.dart';
import '../ui/register_screen.dart';
import '../ui/splash_screen.dart';

class AppRouterDelegate extends RouterDelegate<AppRoutePath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppRoutePath> {
  final GlobalKey<NavigatorState> navigatorKey;

  AppRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final routePath = ModalRoute.of(context)?.settings.name;

    return Navigator(
      key: navigatorKey,
      pages: _buildPages(routePath),
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        notifyListeners();

        return true;
      },
    );
  }

  List<Page> _buildPages(String? routePath) {
    if (routePath == null) {
      return [SplashScreenPage()];
    } else {
      switch (routePath) {
        case '/login':
          return [LoginScreenPage()];
        case '/register':
          return [RegisterScreenPage()];
        case '/home':
          return [HomeScreenPage()];
        default:
        // Handle unknown pages
          return [SplashScreenPage()];
      }
    }
  }

  @override
  Future<void> setNewRoutePath(AppRoutePath path) async {
    // Implement if needed
  }

  void replaceRoute(AppRoutePath path) {
    navigatorKey.currentState?.pushReplacementNamed(path.location);
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppRoutePath> {
  @override
  Future<AppRoutePath> parseRouteInformation(
      RouteInformation routeInformation) async {
    final uri = Uri.parse(routeInformation.location!);

    if (uri.pathSegments.isEmpty) {
      return AppRoutePath.home();
    } else {
      final page = uri.pathSegments.last;
      switch (page) {
        case 'login':
          return AppRoutePath.login();
        case 'register':
          return AppRoutePath.register();
        case 'home':
          return AppRoutePath.home();
        default:
          return AppRoutePath.unknown();
      }
    }
  }

  @override
  RouteInformation restoreRouteInformation(AppRoutePath path) {
    return RouteInformation(location: path.location);
  }
}

class AppRoutePath {
  final String location;

  AppRoutePath.home() : location = '/';
  AppRoutePath.login() : location = '/login';
  AppRoutePath.register() : location = '/register';

  AppRoutePath.unknown() : location = '/unknown'; // Handle unknown pages here
}

class SplashScreenPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const SplashScreen();
      },
    );
  }
}

class LoginScreenPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return LoginScreen();
      },
    );
  }
}

class RegisterScreenPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return RegisterScreen();
      },
    );
  }
}

class HomeScreenPage extends Page {
  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const HomeScreen();
      },
    );
  }
}
