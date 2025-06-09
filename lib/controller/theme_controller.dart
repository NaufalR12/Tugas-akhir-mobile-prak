import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();
  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  final _logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromPrefs();
  }

  void _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Hapus preferensi tema yang tersimpan
      await prefs.remove('isDarkMode');
      _isDarkMode.value = false;
      _updateTheme();
      _logger.i('Tema diatur ke mode terang (default)');
    } catch (e) {
      _logger.e('Error saat memuat tema: $e');
      // Pastikan tema terang sebagai fallback
      _isDarkMode.value = false;
      _updateTheme();
    }
  }

  void toggleTheme() async {
    _isDarkMode.value = !_isDarkMode.value;
    _updateTheme();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isDarkMode', _isDarkMode.value);
      _logger.i('Tema diubah ke: ${_isDarkMode.value ? 'gelap' : 'terang'}');
    } catch (e) {
      _logger.e('Error saat menyimpan tema: $e');
    }
  }

  void _updateTheme() {
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
