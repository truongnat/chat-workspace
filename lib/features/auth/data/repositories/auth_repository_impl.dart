import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../core/services/crypto_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage storage;
  final CryptoService cryptoService;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.cryptoService,
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
      
      // Check if keys exist locally, if not generate and upload
      // Note: In a real app, we might want to check if the server already has a public key
      // and if so, we might need to recover the private key (which is complex) or regenerate (which invalidates old messages).
      // For this MVP, we'll generate if missing locally and upload.
      final existingPublicKey = await cryptoService.getMyPublicKey();
      if (existingPublicKey == null) {
        final newPublicKey = await cryptoService.generateAndSaveKeys();
        await remoteDataSource.uploadPublicKey(newPublicKey);
      }

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
      
      // Generate and upload keys
      final newPublicKey = await cryptoService.generateAndSaveKeys();
      await remoteDataSource.uploadPublicKey(newPublicKey);

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

  @override
  Future<Either<Failure, String?>> getUserPublicKey(String userId) async {
    try {
      final key = await remoteDataSource.getPublicKey(userId);
      return Right(key);
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }
}
