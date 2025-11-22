import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/user.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String phone, String password);
  Future<void> verifyOtp(String phone, String otp);
  Future<Map<String, dynamic>> register(String phone, String password, String name);
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
