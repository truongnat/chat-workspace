import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/theme/app_theme.dart';
import 'router/app_router.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/settings/presentation/providers/theme_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize SharedPreferences
  final sharedPreferences = await SharedPreferences.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        // Override SharedPreferences provider for Auth feature
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        // Override SharedPreferences provider for Settings feature
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final currentTheme = ref.watch(currentThemeProvider);

    return MaterialApp.router(
      title: 'Secure Chat',
      theme: AppTheme.darkTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
