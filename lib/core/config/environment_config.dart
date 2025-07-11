// lib/core/config/environment_config.dart
enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  static Environment get currentEnvironment {
    const env = String.fromEnvironment('ENV', defaultValue: 'development');
    switch (env) {
      case 'production':
        return Environment.production;
      case 'staging':
        return Environment.staging;
      default:
        return Environment.development;
    }
  }

  static Map<String, dynamic> get config {
    switch (currentEnvironment) {
      case Environment.production:
        return _productionConfig;
      case Environment.staging:
        return _stagingConfig;
      case Environment.development:
        return _developmentConfig;
    }
  }

  static const Map<String, dynamic> _productionConfig = {
    'apiBaseUrl': 'https://api.skinsense.com',
    'modelBaseUrl': 'https://models.skinsense.com',
    'enableLogging': false,
    'enableDebugPrints': false,
    'enableCrashlytics': true,
    'enableAnalytics': true,
    'apiTimeout': 30000,
    'retryAttempts': 3,
    'cacheExpiry': 3600000, // 1 hour
  };

  static const Map<String, dynamic> _stagingConfig = {
    'apiBaseUrl': 'https://staging-api.skinsense.com',
    'modelBaseUrl': 'https://staging-models.skinsense.com',
    'enableLogging': true,
    'enableDebugPrints': true,
    'enableCrashlytics': true,
    'enableAnalytics': false,
    'apiTimeout': 45000,
    'retryAttempts': 2,
    'cacheExpiry': 1800000, // 30 minutes
  };

  static const Map<String, dynamic> _developmentConfig = {
    'apiBaseUrl': 'https://dev-api.skinsense.com',
    'modelBaseUrl': 'https://dev-models.skinsense.com',
    'enableLogging': true,
    'enableDebugPrints': true,
    'enableCrashlytics': false,
    'enableAnalytics': false,
    'apiTimeout': 60000,
    'retryAttempts': 1,
    'cacheExpiry': 300000, // 5 minutes
  };

  static T getValue<T>(String key, T defaultValue) {
    return config[key] as T? ?? defaultValue;
  }
}