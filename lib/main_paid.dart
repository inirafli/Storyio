import 'package:flutter/material.dart';
import 'common/flavor_config.dart';
import 'my_app.dart';

void main() {
  FlavorConfig(
    flavor: FlavorType.paid,
    values: const FlavorValues(
      titleApp: "Storyio Pro",
    ),
  );

  runApp(const MyApp());
}
