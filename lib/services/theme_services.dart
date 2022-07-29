import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final _box = GetStorage();
  final _key = "isDarkMode";
  _saveThemeInStorage(bool isDarkMode) => _box.write(_key, isDarkMode);
  bool _loadThemeFromStorage() => _box.read(_key) ?? false;
  ThemeMode get theme =>
      _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;
  void updateTheme() {
    Get.changeThemeMode(
        _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light);
    _saveThemeInStorage(!_loadThemeFromStorage());
  }
}
