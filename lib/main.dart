import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:storyio/common/styles.dart';
import 'package:storyio/preferences/auth_preferences.dart';
import 'package:storyio/provider/auth_provider.dart';
import 'package:storyio/provider/story_provider.dart';
import 'package:storyio/routes/router_delegate.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late MyRouterDelegate myRouterDelegate;

  @override
  void initState() {
    super.initState();

    final authPreferences = AuthPreferences();
    myRouterDelegate = MyRouterDelegate(authPreferences);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => StoryProvider()),
      ],
      child: MaterialApp(
        title: 'Storyio',
        theme: ThemeData(
          colorScheme: Theme
              .of(context)
              .colorScheme
              .copyWith(
            primary: primaryColor,
            secondary: secondaryColor,
            surface: subPrimaryColor,
            onPrimary: backgroundColor,
            onSecondary: textColor,
            background: backgroundColor,
          ),
          appBarTheme: const AppBarTheme(
            scrolledUnderElevation: 0.0,
            backgroundColor: backgroundColor,
            foregroundColor: primaryColor,
          ),
          cardTheme: const CardTheme(
            color: backgroundColor,
            elevation: 2.0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: backgroundColor,
                disabledBackgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              )
          ),
          snackBarTheme: SnackBarThemeData(
            contentTextStyle: Theme
                .of(context)
                .textTheme
                .titleSmall
                ?.copyWith(
              color: Theme
                  .of(context)
                  .colorScheme
                  .background,
            ),
            backgroundColor: primaryColor,
          ),
          textTheme: appTextTheme,
        ),
        home: Router(
          routerDelegate: myRouterDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}