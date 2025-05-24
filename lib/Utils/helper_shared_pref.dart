// import 'package:shared_preferences/shared_preferences.dart';
//
// class SharedPrefHelper {
//   // Singleton pattern
//   static final SharedPrefHelper _instance = SharedPrefHelper._internal();
//
//   factory SharedPrefHelper() => _instance;
//
//   SharedPrefHelper._internal();
//
//   static SharedPreferences? _prefs;
//
//   // Initialize SharedPreferences instance (call once before using)
//   static Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }
//
//   // Save any data (supports String, int, bool, double, List<String>)
//   Future<bool> saveData(String key, dynamic value) async {
//     if (_prefs == null) await init();
//
//     if (value is String) return await _prefs!.setString(key, value);
//     if (value is int) return await _prefs!.setInt(key, value);
//     if (value is bool) return await _prefs!.setBool(key, value);
//     if (value is double) return await _prefs!.setDouble(key, value);
//     if (value is List<String>) return await _prefs!.setStringList(key, value);
//
//     throw Exception("Unsupported value type");
//   }
//
//   // Get data of generic type, returns null if not found
//   dynamic getData(String key) {
//     if (_prefs == null) throw Exception("SharedPreferences not initialized");
//
//     return _prefs!.get(key);
//   }
//
//   // Remove a key
//   Future<bool> removeData(String key) async {
//     if (_prefs == null) await init();
//     return await _prefs!.remove(key);
//   }
//
//   // Clear all stored data
//   Future<bool> clearAll() async {
//     if (_prefs == null) await init();
//     return await _prefs!.clear();
//   }
//
//   // Specific getter helpers (optional)
//
//   String? getString(String key) {
//     if (_prefs == null) throw Exception("SharedPreferences not initialized");
//     return _prefs!.getString(key);
//   }
//
//   int? getInt(String key) {
//     if (_prefs == null) throw Exception("SharedPreferences not initialized");
//     return _prefs!.getInt(key);
//   }
//
//   bool? getBool(String key) {
//     if (_prefs == null) throw Exception("SharedPreferences not initialized");
//     return _prefs!.getBool(key);
//   }
//
//   double? getDouble(String key) {
//     if (_prefs == null) throw Exception("SharedPreferences not initialized");
//     return _prefs!.getDouble(key);
//   }
//
//   List<String>? getStringList(String key) {
//     if (_prefs == null) throw Exception("SharedPreferences not initialized");
//     return _prefs!.getStringList(key);
//   }
// }



///
/// Todo:: updating for userId
///



import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static final SharedPrefHelper _instance = SharedPrefHelper._internal();
  factory SharedPrefHelper() => _instance;
  SharedPrefHelper._internal();

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> saveData(String key, dynamic value) async {
    if (_prefs == null) await init();

    if (value is String) return await _prefs!.setString(key, value);
    if (value is int) return await _prefs!.setInt(key, value);
    if (value is bool) return await _prefs!.setBool(key, value);
    if (value is double) return await _prefs!.setDouble(key, value);
    if (value is List<String>) return await _prefs!.setStringList(key, value);

    throw Exception("Unsupported value type");
  }

  dynamic getData(String key) {
    if (_prefs == null) throw Exception("SharedPreferences not initialized");
    return _prefs!.get(key);
  }

  Future<bool> removeData(String key) async {
    if (_prefs == null) await init();
    return await _prefs!.remove(key);
  }

  Future<bool> clearAll() async {
    if (_prefs == null) await init();
    return await _prefs!.clear();
  }

  String? getString(String key) => _prefs?.getString(key);
  int? getInt(String key) => _prefs?.getInt(key);
  bool? getBool(String key) => _prefs?.getBool(key);
  double? getDouble(String key) => _prefs?.getDouble(key);
  List<String>? getStringList(String key) => _prefs?.getStringList(key);
}
