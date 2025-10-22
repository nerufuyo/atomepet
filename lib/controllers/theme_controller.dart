import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final RxBool isDarkMode = false.obs;

  static const String _themePrefKey = 'theme_mode';

  @override
  void onInit() {
    super.onInit();
    loadThemeFromPrefs();
  }

  Future<void> loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedTheme = prefs.getString(_themePrefKey);
      if (savedTheme != null) {
        themeMode.value = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == savedTheme,
          orElse: () => ThemeMode.system,
        );
        _updateDarkModeStatus();
      }
    } catch (e) {
      themeMode.value = ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    try {
      themeMode.value = mode;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_themePrefKey, mode.toString());
      Get.changeThemeMode(mode);
      _updateDarkModeStatus();
    } catch (e) {
      Get.snackbar(
        'error'.tr,
        'Failed to change theme',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void toggleTheme() {
    if (themeMode.value == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }

  void setLightMode() {
    setThemeMode(ThemeMode.light);
  }

  void setDarkMode() {
    setThemeMode(ThemeMode.dark);
  }

  void setSystemMode() {
    setThemeMode(ThemeMode.system);
  }

  void _updateDarkModeStatus() {
    if (themeMode.value == ThemeMode.system) {
      isDarkMode.value = Get.isDarkMode;
    } else {
      isDarkMode.value = themeMode.value == ThemeMode.dark;
    }
  }
}
