import 'package:flutter/material.dart';
import 'package:storyio/common/styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
        textTheme: appTextTheme,
      ),
    );
  }
}