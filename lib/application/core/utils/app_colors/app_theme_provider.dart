import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemeMode {
  light,
  dark,
  system,
}

final appThemeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<AppThemeMode> {
  static const String _themeKey = 'app_theme_mode';
  
  ThemeNotifier() : super(AppThemeMode.light) {
    _loadSavedTheme();
  }
  
  Future<void> _loadSavedTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      state = AppThemeMode.values[themeIndex];
    } catch (e) {
      // Fallback to light theme if loading fails
      state = AppThemeMode.light;
    }
  }
  
  Future<void> setTheme(AppThemeMode theme) async {
    state = theme;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_themeKey, theme.index);
    } catch (e) {
      // Handle error silently
    }
  }
}
