enum FlavorType {
  free,
  paid,
}

class FlavorValues {
  final String titleApp;

  const FlavorValues({
    this.titleApp = "Storyio",
  });
}

class FlavorConfig {
  final FlavorType flavor;
  final FlavorValues values;

  static FlavorConfig? _instance;

  FlavorConfig({
    this.flavor = FlavorType.paid,
    this.values = const FlavorValues(),
  }) {
    _instance = this;
  }

  static FlavorConfig get instance => _instance ?? FlavorConfig();
}
