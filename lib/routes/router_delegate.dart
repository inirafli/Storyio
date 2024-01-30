// import 'package:flutter/material.dart';
// import 'package:storyio/preferences/auth_preferences.dart';
// import 'package:storyio/ui/home_screen.dart';
//
// import '../ui/login_screen.dart';
// import '../ui/register_screen.dart';
// import '../ui/splash_screen.dart';
//
// class MyRouterDelegate extends RouterDelegate
//     with ChangeNotifier, PopNavigatorRouterDelegateMixin {
//   final GlobalKey<NavigatorState> _navigatorKey;
//
//   MyRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>() {
//     _init();
//   }
//
//   _init() async {
//     historyStack = _splashStack;
//     isLoggedIn = await AuthPreferences.isLoggedIn();
//     notifyListeners();
//   }
//
//   List<Page> historyStack = [];
//   bool? isLoggedIn;
//   bool isRegister = false;
//
//   List<Page> get _splashStack => [
//         MaterialPage(
//           key: const ValueKey("SplashPage"),
//           child: SplashScreen(
//             isLogin: () {
//               isLoggedIn = true;
//               notifyListeners();
//             },
//             isNotLogin: () {
//               isLoggedIn = false;
//               notifyListeners();
//             },
//           ),
//         ),
//       ];
//
//   List<Page> get _loggedOutStack => [
//         MaterialPage(
//           key: const ValueKey("LoginPage"),
//           child: LoginScreen(
//             onLogin: () {
//               isLoggedIn = true;
//               notifyListeners();
//             },
//             onRegister: () {
//               isRegister = true;
//               notifyListeners();
//             },
//           ),
//         ),
//         if (isRegister == true)
//           MaterialPage(
//             key: const ValueKey("RegisterPage"),
//             child: RegisterScreen(
//               onRegister: () {
//                 isRegister = false;
//                 notifyListeners();
//               },
//               onLogin: () {
//                 isRegister = false;
//                 notifyListeners();
//               },
//             ),
//           ),
//       ];
//
//   List<Page> get _loggedInStack => [
//         MaterialPage(
//           key: const ValueKey("HomePage"),
//           child: HomeScreen(
//             onLogout: () {
//               isLoggedIn = false;
//               notifyListeners();
//             },
//           ),
//         ),
//       ];
//
//   @override
//   Widget build(BuildContext context) {
//     if (isLoggedIn == true) {
//       historyStack = _loggedInStack;
//     } else {
//       historyStack = _loggedOutStack;
//     }
//
//     return Navigator(
//         key: navigatorKey,
//         pages: historyStack,
//         onPopPage: (route, result) {
//           final didPop = route.didPop(result);
//           if (!didPop) {
//             return false;
//           }
//
//           isRegister = false;
//           notifyListeners();
//
//           return true;
//         });
//   }
//
//   @override
//   GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;
//
//   @override
//   Future<void> setNewRoutePath(configuration) {
//     throw UnimplementedError();
//   }
// }
