// lib/core/utils/cache_utils.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheUtils {
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) {
    return _prefs?.getString(key);
  }

  static Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  static int? getInt(String key) {
    return _prefs?.getInt(key);
  }

  static Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  static bool? getBool(String key) {
    return _prefs?.getBool(key);
  }

  static Future<void> setDouble(String key, double value) async {
    await _prefs?.setDouble(key, value);
  }

  static double? getDouble(String key) {
    return _prefs?.getDouble(key);
  }

  static Future<void> setObject(String key, Map<String, dynamic> value) async {
    final jsonString = jsonEncode(value);
    await setString(key, jsonString);
  }

  static Map<String, dynamic>? getObject(String key) {
    final jsonString = getString(key);
    if (jsonString != null) {
      try {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  static Future<void> setList(String key, List<String> value) async {
    await _prefs?.setStringList(key, value);
  }

  static List<String>? getList(String key) {
    return _prefs?.getStringList(key);
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }

  static Set<String> getKeys() {
    return _prefs?.getKeys() ?? {};
  }

  static bool containsKey(String key) {
    return _prefs?.containsKey(key) ?? false;
  }

  // Cache management methods
  static Future<void> cacheWithExpiry(
      String key,
      Map<String, dynamic> value,
      Duration expiry,
      ) async {
    final cacheData = {
      'data': value,
      'expiry': DateTime.now().add(expiry).millisecondsSinceEpoch,
    };
    await setObject(key, cacheData);
  }

  static Map<String, dynamic>? getCachedData(String key) {
    final cacheData = getObject(key);
    if (cacheData != null) {
      final expiry = cacheData['expiry'] as int?;
      if (expiry != null && DateTime.now().millisecondsSinceEpoch < expiry) {
        return cacheData['data'] as Map<String, dynamic>?;
      } else {
        // Remove expired data
        remove(key);
      }
    }
    return null;
  }

  static Future<void> clearExpiredCache() async {
    final keys = getKeys();
    for (final key in keys) {
      final cacheData = getObject(key);
      if (cacheData != null && cacheData.containsKey('expiry')) {
        final expiry = cacheData['expiry'] as int?;
        if (expiry != null && DateTime.now().millisecondsSinceEpoch >= expiry) {
          await remove(key);
        }
      }
    }
  }
}