import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/theme_local_datasource.dart';
import '../../data/repositories/theme_repository_impl.dart';
import '../../domain/entities/app_theme_data.dart';
import '../../domain/repositories/theme_repository.dart';
import '../../domain/usecases/get_theme.dart';
import '../../domain/usecases/save_theme.dart';

// Shared Preferences Provider (must be overridden in main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

// Data Sources
final themeLocalDataSourceProvider = Provider<ThemeLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return ThemeLocalDataSourceImpl(sharedPreferences: prefs);
});

// Repository
final themeRepositoryProvider = Provider<ThemeRepository>((ref) {
  return ThemeRepositoryImpl(
    localDataSource: ref.watch(themeLocalDataSourceProvider),
  );
});

// Use Cases
final getThemeUseCaseProvider = Provider<GetTheme>((ref) {
  return GetTheme(ref.watch(themeRepositoryProvider));
});

final saveThemeUseCaseProvider = Provider<SaveTheme>((ref) {
  return SaveTheme(ref.watch(themeRepositoryProvider));
});

// State Provider for current theme
final currentThemeProvider = StateNotifierProvider<ThemeNotifier, AppThemeData>((ref) {
  return ThemeNotifier(
    ref.watch(getThemeUseCaseProvider),
    ref.watch(saveThemeUseCaseProvider),
  );
});

class ThemeNotifier extends StateNotifier<AppThemeData> {
  final GetTheme getTheme;
  final SaveTheme saveTheme;

  ThemeNotifier(this.getTheme, this.saveTheme) : super(AppThemeData.defaultDark) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final result = await getTheme(const NoParams());
    result.fold(
      (failure) => state = AppThemeData.defaultDark,
      (theme) => state = theme,
    );
  }

  Future<void> setTheme(AppThemeData theme) async {
    state = theme;
    await saveTheme(SaveThemeParams(theme: theme));
  }

  Future<void> resetToDefault() async {
    state = AppThemeData.defaultDark;
    await saveTheme(SaveThemeParams(theme: AppThemeData.defaultDark));
  }
}
