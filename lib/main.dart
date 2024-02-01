import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyio/common/styles.dart';
import 'package:storyio/data/api/api_services.dart';
import 'package:storyio/preferences/auth_preferences.dart';
import 'package:storyio/provider/auth_provider.dart';
import 'package:storyio/ui/home_screen.dart';
import 'package:storyio/ui/login_screen.dart';
import 'package:storyio/ui/register_screen.dart';
import 'package:storyio/ui/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AuthProvider(),
      child: MaterialApp(
        title: 'Storyio',
        theme: ThemeData(
          colorScheme:Theme.of(context).colorScheme.copyWith(
            primary: primaryColor,
            secondary:secondaryColor,
            surface: subPrimaryColor,
            onPrimary: backgroundColor,
            onSecondary: textColor,
            background: backgroundColor,
          ),
          appBarTheme: const AppBarTheme(
            titleTextStyle: TextStyle(
              color: backgroundColor,
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              foregroundColor: backgroundColor,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
            )
          ),
          snackBarTheme: SnackBarThemeData(
            contentTextStyle: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: Theme.of(context).colorScheme.background,
            ),
            backgroundColor: primaryColor,
          ),
          textTheme: appTextTheme,
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => SplashScreen());
            case '/login':
              return MaterialPageRoute(builder: (context) => LoginScreen());
            case '/register':
              return MaterialPageRoute(builder: (context) => RegisterScreen());
            case '/home':
              return MaterialPageRoute(builder: (context) => HomeScreen());
            default:
              return MaterialPageRoute(builder: (context) => SplashScreen());
          }
        },
      ),
    );
  }
}