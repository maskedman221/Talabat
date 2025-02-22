import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

static Future<void> saveData(String key, dynamic value) async {
  if (value is String) {
    await _prefs?.setString(key, value);
  } else if (value is int) {
    await _prefs?.setInt(key, value);
  } else if (value is bool) {
    await _prefs?.setBool(key, value);
  } else if (value is double) {
    await _prefs?.setDouble(key, value);
  } else if (value is Map || value is List) {
    // Serialize Map or List into a JSON string
    await _prefs?.setString(key, jsonEncode(value));
  } else {
    throw Exception("Unsupported data type for SharedPreferences");
  }
}

  static dynamic getData(String key) {
    return _prefs?.get(key);
  }

  static Future<void> removeData(String key) async {
    await _prefs?.remove(key);
  }

  static Future<void> clearAllData() async {
    await _prefs?.clear();
  }
}