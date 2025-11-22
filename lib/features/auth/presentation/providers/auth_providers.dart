import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/datasources/auth_local_datasource.dart';
import '../../data/datasources/auth_remote_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/create_profile.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/verify_otp.dart';

// Data Sources
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSourceImpl();
});

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return AuthLocalDataSourceImpl(sharedPreferences: prefs);
});

// Repository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
    localDataSource: ref.watch(authLocalDataSourceProvider),
  );
});

// Use Cases
final sendOtpUseCaseProvider = Provider<SendOtp>((ref) {
  return SendOtp(ref.watch(authRepositoryProvider));
});

final verifyOtpUseCaseProvider = Provider<VerifyOtp>((ref) {
  return VerifyOtp(ref.watch(authRepositoryProvider));
});

final createProfileUseCaseProvider = Provider<CreateProfile>((ref) {
  return CreateProfile(ref.watch(authRepositoryProvider));
});

// Shared Preferences Provider (must be overridden in main.dart)
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});
