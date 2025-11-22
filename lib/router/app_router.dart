import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/screens/splash_screen.dart';
import '../features/auth/screens/phone_entry_screen.dart';
import '../features/auth/screens/otp_verification_screen.dart';
import '../features/auth/screens/profile_creation_screen.dart';
import '../features/home/screens/main_screen.dart';
import '../features/chat/screens/chat_detail_screen.dart';
import '../features/chat/screens/video_call_screen.dart';
import '../features/settings/screens/privacy_settings_screen.dart';
import '../features/settings/screens/security_settings_screen.dart';
import '../features/settings/screens/premium_screen.dart';
import '../features/settings/screens/account_details_screen.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth/phone',
        builder: (context, state) => const PhoneEntryScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/auth/profile',
        builder: (context, state) => const ProfileCreationScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const MainScreen(),
      ),
      GoRoute(
        path: '/chat/:id/:name',
        builder: (context, state) => ChatDetailScreen(
          contactId: state.pathParameters['id']!,
          contactName: state.pathParameters['name']!,
        ),
      ),
      GoRoute(
        path: '/video-call/:id/:name',
        builder: (context, state) => VideoCallScreen(
          contactId: state.pathParameters['id']!,
          contactName: state.pathParameters['name']!,
        ),
      ),
      GoRoute(
        path: '/settings/privacy',
        builder: (context, state) => const PrivacySettingsScreen(),
      ),
      GoRoute(
        path: '/settings/security',
        builder: (context, state) => const SecuritySettingsScreen(),
      ),
      GoRoute(
        path: '/settings/premium',
        builder: (context, state) => const PremiumScreen(),
      ),
      GoRoute(
        path: '/settings/account',
        builder: (context, state) => const AccountDetailsScreen(),
      ),
    ],
  );
});
