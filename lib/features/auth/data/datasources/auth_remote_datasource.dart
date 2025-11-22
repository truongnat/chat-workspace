import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<void> sendOtp(String phoneNumber);
  Future<UserModel> verifyOtp(String phoneNumber, String otp);
  Future<UserModel> createProfile({
    required String userId,
    required String name,
    String? username,
    String? bio,
    String? avatarUrl,
  });
  Future<UserModel> getCurrentUser();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // In a real app, this would use http/dio for API calls
  
  @override
  Future<void> sendOtp(String phoneNumber) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // In real implementation: POST /api/auth/send-otp
  }

  @override
  Future<UserModel> verifyOtp(String phoneNumber, String otp) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // In real implementation: POST /api/auth/verify-otp
    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      phoneNumber: phoneNumber,
      name: '',
      createdAt: DateTime.now(),
      isOnline: true,
    );
  }

  @override
  Future<UserModel> createProfile({
    required String userId,
    required String name,
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    // In real implementation: POST /api/auth/create-profile
    return UserModel(
      id: userId,
      phoneNumber: '+1234567890',
      name: name,
      username: username,
      bio: bio,
      avatarUrl: avatarUrl,
      createdAt: DateTime.now(),
      isOnline: true,
    );
  }

  @override
  Future<UserModel> getCurrentUser() async {
    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 500));
    // In real implementation: GET /api/auth/me
    throw Exception('Not authenticated');
  }
}
