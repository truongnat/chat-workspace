import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global auth state provider to handle logout events
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier();
});

enum AuthState {
  authenticated,
  unauthenticated,
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(AuthState.unauthenticated);

  void login() {
    state = AuthState.authenticated;
  }

  void logout() {
    state = AuthState.unauthenticated;
  }
}
