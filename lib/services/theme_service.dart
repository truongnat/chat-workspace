import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_theme_data.dart';

class ThemeService extends StateNotifier<AppThemeData> {
  static const String _themeKey = 'app_theme';
  final SharedPreferences _prefs;

  ThemeService(this._prefs) : super(AppThemeData.defaultDark) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeJson = _prefs.getString(_themeKey);
    if (themeJson != null) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(themeJson);
        state = AppThemeData.fromJson(decoded);
      } catch (e) {
        // If loading fails, keep default theme
        state = AppThemeData.defaultDark;
      }
    }
  }

  Future<void> setTheme(AppThemeData theme) async {
    state = theme;
    await _prefs.setString(_themeKey, jsonEncode(theme.toJson()));
  }

  Future<void> updateBubbleColorSent(int colorValue) async {
    final newTheme = state.copyWith(
      bubbleColorSent: Color(colorValue),
    );
    await setTheme(newTheme);
  }

  Future<void> updateBubbleColorReceived(int colorValue) async {
    final newTheme = state.copyWith(
      bubbleColorReceived: Color(colorValue),
    );
    await setTheme(newTheme);
  }

  Future<void> updateBackgroundColor(int colorValue) async {
    final newTheme = state.copyWith(
      backgroundColor: Color(colorValue),
    );
    await setTheme(newTheme);
  }

  Future<void> resetToDefault() async {
    await setTheme(AppThemeData.defaultDark);
  }
}

// Provider for SharedPreferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

// Provider for ThemeService
final themeServiceProvider = StateNotifierProvider<ThemeService, AppThemeData>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeService(prefs);
});
