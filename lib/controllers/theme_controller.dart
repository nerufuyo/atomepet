import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ThemeController extends GetxController {
  final Rx<ThemeMode> themeMode = ThemeMode.light.obs;
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Always force light mode
    setLightMode();
  }

  Future<void> loadThemeFromPrefs() async {
    // Always use light mode
    themeMode.value = ThemeMode.light;
    isDarkMode.value = false;
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    // Always force light mode
    themeMode.value = ThemeMode.light;
    isDarkMode.value = false;
    Get.changeThemeMode(ThemeMode.light);
  }

  void toggleTheme() {
    // Do nothing - always stay in light mode
    setLightMode();
  }

  void setLightMode() {
    themeMode.value = ThemeMode.light;
    isDarkMode.value = false;
    Get.changeThemeMode(ThemeMode.light);
  }

  void setDarkMode() {
    // Do nothing - always stay in light mode
    setLightMode();
  }

  void setSystemMode() {
    // Do nothing - always stay in light mode
    setLightMode();
  }
}
