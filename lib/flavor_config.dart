enum FlavorType {
  free,
  paid,
}

class FlavorValues {
  final String titleApp;
  final bool canAddLocation;

  const FlavorValues({
    this.titleApp = "StoryMap",
    this.canAddLocation = false,
  });
}

class FlavorConfig {
  final FlavorType flavor;
  final FlavorValues values;

  static FlavorConfig? _instance;

  FlavorConfig({
    required this.flavor,
    required this.values,
  }) {
    _instance = this;
  }

  static FlavorConfig get instance => _instance ?? FlavorConfig(flavor: FlavorType.free, values: const FlavorValues());

  static bool get isFreeVersion => _instance?.flavor == FlavorType.free;
  static bool get isPaidVersion => _instance?.flavor == FlavorType.paid;
}
