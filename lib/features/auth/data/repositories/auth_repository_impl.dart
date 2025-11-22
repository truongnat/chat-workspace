import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage storage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    this.storage = const FlutterSecureStorage(),
  });

  @override
  Future<Either<Failure, User>> login(String phone, String password) async {
    try {
      final response = await remoteDataSource.login(phone, password);
      
      // Cache token
      final token = response['token'];
      if (token != null) {
        await storage.write(key: 'auth_token', value: token);
      }

      // Map response to User entity
      // Assuming response['user'] contains user data
      final userJson = response['user'];
      final user = User(
        id: userJson['id'],
        phoneNumber: userJson['phone_number'],
        name: userJson['name'] ?? '',
        // Add other fields as necessary
      );
      
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String phone, String otp) async {
    try {
      await remoteDataSource.verifyOtp(phone, otp);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register(String phone, String password, String name) async {
    try {
      final response = await remoteDataSource.register(phone, password, name);
      
      // Cache token
      final token = response['token'];
      if (token != null) {
        await storage.write(key: 'auth_token', value: token);
      }

      final userJson = response['user'];
      final user = User(
        id: userJson['id'],
        phoneNumber: userJson['phone_number'],
        name: userJson['name'] ?? '',
      );
      
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
  
  // Implement other methods...
  @override
  Future<Either<Failure, void>> logout() async {
    await storage.delete(key: 'auth_token');
    return const Right(null);
  }
  
  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    // TODO: Implement get current user
    return Left(ServerFailure(message: "Not implemented"));
  }
}
