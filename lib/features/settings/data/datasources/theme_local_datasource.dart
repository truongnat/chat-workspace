import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_theme_data_model.dart';

abstract class ThemeLocalDataSource {
  Future<AppThemeDataModel> getTheme();
  Future<void> saveTheme(AppThemeDataModel theme);
  Future<void> clearTheme();
}

class ThemeLocalDataSourceImpl implements ThemeLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String themeKey = 'APP_THEME';

  ThemeLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<AppThemeDataModel> getTheme() async {
    final jsonString = sharedPreferences.getString(themeKey);
    if (jsonString != null) {
      return AppThemeDataModel.fromJson(jsonDecode(jsonString));
    } else {
      // Return default theme
      return const AppThemeDataModel(
        bubbleColorSent: Color(0xFF2D68FF),
        bubbleColorReceived: Color(0xFF1C1F2A),
        backgroundColor: Color(0xFF0B0E14),
        surfaceColor: Color(0xFF1C1F2A),
        fontFamily: 'Inter',
      );
    }
  }

  @override
  Future<void> saveTheme(AppThemeDataModel theme) async {
    await sharedPreferences.setString(
      themeKey,
      jsonEncode(theme.toJson()),
    );
  }

  @override
  Future<void> clearTheme() async {
    await sharedPreferences.remove(themeKey);
  }
}
