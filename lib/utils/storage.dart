import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// 使用 share_preference 第三方库做本地存储.
/// Data may be persisted to disk asynchronously,
/// and there is no guarantee that writes will be persisted to disk after returning,
/// so this plugin must not be used for storing critical data.
class StorageUtil {
  static StorageUtil _instance = new StorageUtil._();

  factory StorageUtil() => _instance;

  StorageUtil._();

  static SharedPreferences? _pref;

  /// 必须先调用该方法进行初始化.
  static Future<void> init() async {
    _pref ??= await SharedPreferences.getInstance();
  }

  /// 设置 json 对象
  Future<bool> setJson(String key, dynamic value) async {
    String json = jsonEncode(value);
    return _pref!.setString(key, json);
  }

  /// 获取 json 对象
  dynamic getJSON(String key) {
    String? jsonString = _pref!.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  Future<bool> setBool(String key, bool val) {
    return _pref!.setBool(key, val);
  }

  bool getBool(String key) {
    return _pref!.getBool(key) ?? false;
  }

  Future<bool> remove(String key) {
    return _pref!.remove(key);
  }

  Set<String> getKeys() {
    return _pref!.getKeys();
  }
}
