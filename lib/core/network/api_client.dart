import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_state_provider.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  late final Dio dio;
  final _storage = const FlutterSecureStorage();
  WidgetRef? _ref;

  factory ApiClient() {
    return _instance;
  }

  void setRef(WidgetRef ref) {
    _ref = ref;
  }

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'http://10.0.2.2:8080/api', // Updated to 8080 as per backend config
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Add Auth Token
          final token = await _storage.read(key: 'auth_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // Trigger Logout Event
            print('Unauthorized: Triggering Logout');
            await _storage.delete(key: 'auth_token');
            _ref?.read(authStateProvider.notifier).logout();
          }
          return handler.next(e);
        },
      ),
    );
  }
}
