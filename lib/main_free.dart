import 'package:flutter/material.dart';
import 'common/flavor_config.dart';
import 'my_app.dart';

void main() {
  FlavorConfig(
    flavor: FlavorType.free,
    values: const FlavorValues(
      titleApp: "Storyio Free",
    ),
  );

  runApp(const MyApp());
}
