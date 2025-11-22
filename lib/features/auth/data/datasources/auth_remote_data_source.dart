import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String phone, String password);
  Future<void> verifyOtp(String phone, String otp);
  Future<Map<String, dynamic>> register(String phone, String password, String name);
  Future<void> uploadPublicKey(String publicKey);
  Future<String?> getPublicKey(String userId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> login(String phone, String password) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/login',
        data: {
          'phone_number': phone,
          'password': password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> verifyOtp(String phone, String otp) async {
    try {
      await apiClient.dio.post(
        '/auth/verify-otp',
        data: {
          'phone_number': phone,
          'otp': otp,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<Map<String, dynamic>> register(String phone, String password, String name) async {
    try {
      final response = await apiClient.dio.post(
        '/auth/register',
        data: {
          'phone_number': phone,
          'password': password,
          'name': name,
        },
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<void> uploadPublicKey(String publicKey) async {
    try {
      await apiClient.dio.post(
        '/keys/upload',
        data: {
          'public_key': publicKey,
        },
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  @override
  Future<String?> getPublicKey(String userId) async {
    try {
      final response = await apiClient.dio.get('/users/$userId/key');
      return response.data['public_key'];
    } on DioException catch (e) {
      // If 404, maybe user hasn't uploaded key yet
      if (e.response?.statusCode == 404) return null;
      throw _handleError(e);
    }
  }

  Exception _handleError(DioException e) {
    if (e.response != null) {
      // Parse backend error message
      final message = e.response?.data['error'] ?? 'Server Error';
      return Exception(message);
    } else {
      return Exception('Network Error');
    }
  }
}
