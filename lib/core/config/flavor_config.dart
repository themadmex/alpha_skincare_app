// lib/core/config/flavor_config.dart
enum Flavor {
  development,
  staging,
  production,
}

class FlavorConfig {
  final Flavor flavor;
  final String name;
  final String apiBaseUrl;
  final String modelBaseUrl;
  final bool enableLogging;
  final bool enableCrashlytics;
  final bool enableAnalytics;
  final Map<String, dynamic> values;

  static FlavorConfig? _instance;

  FlavorConfig._internal({
    required this.flavor,
    required this.name,
    required this.apiBaseUrl,
    required this.modelBaseUrl,
    required this.enableLogging,
    required this.enableCrashlytics,
    required this.enableAnalytics,
    required this.values,
  });

  static FlavorConfig get instance {
    assert(_instance != null, 'FlavorConfig must be initialized');
    return _instance!;
  }

  static void initialize({
    required Flavor flavor,
    required String name,
    required String apiBaseUrl,
    required String modelBaseUrl,
    bool enableLogging = true,
    bool enableCrashlytics = false,
    bool enableAnalytics = false,
    Map<String, dynamic> values = const {},
  }) {
    _instance = FlavorConfig._internal(
      flavor: flavor,
      name: name,
      apiBaseUrl: apiBaseUrl,
      modelBaseUrl: modelBaseUrl,
      enableLogging: enableLogging,
      enableCrashlytics: enableCrashlytics,
      enableAnalytics: enableAnalytics,
      values: values,
    );
  }

  static bool get isDevelopment => _instance?.flavor == Flavor.development;
  static bool get isStaging => _instance?.flavor == Flavor.staging;
  static bool get isProduction => _instance?.flavor == Flavor.production;

  T getValue<T>(String key, T defaultValue) {
    return values[key] as T? ?? defaultValue;
  }
}