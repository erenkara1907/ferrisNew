import 'package:ferrisfwt/product/database/hive/core/hive_database_manager.dart';
import 'package:ferrisfwt/product/theme/custom_dark_theme.dart';
import 'package:ferrisfwt/product/theme/custom_light_theme.dart';
import 'package:ferrisfwt/product/utility/enums/app_theme_enum.dart';
import 'package:flutter/material.dart';

class ThemeNotifier extends ChangeNotifier {
  late HiveDatabaseManager _hiveManager;

  ThemeData _currentTheme = CustomLightTheme().themeData;
  AppThemes _currentThemeEnum = AppThemes.LIGHT;

  ThemeNotifier() {
    _hiveManager = HiveDatabaseManager();
    _loadTheme();
  }

  ThemeData get currentTheme => _currentTheme;
  AppThemes get currentThemeEnum => _currentThemeEnum;

  Future<void> _loadTheme() async {
    final themeMode = await _hiveManager.getThemeMode();
    _currentThemeEnum = themeMode ?? AppThemes.LIGHT;
    _currentTheme = _buildTheme(_currentThemeEnum);
    notifyListeners();
  }

  void changeValue(AppThemes theme) async {
    _currentThemeEnum = theme;
    _currentTheme = _buildTheme(theme);
    await _hiveManager.saveThemeMode(theme);
    notifyListeners();
  }

  ThemeData _buildTheme(AppThemes theme) {
    switch (theme) {
      case AppThemes.LIGHT:
        return CustomLightTheme().themeData;
      case AppThemes.DARK:
        return CustomDarkTheme().themeData;
    }
  }
}
