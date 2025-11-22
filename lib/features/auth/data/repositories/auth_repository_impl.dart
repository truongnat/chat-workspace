import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, void>> sendOtp(String phoneNumber) async {
    try {
      await remoteDataSource.sendOtp(phoneNumber);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> verifyOtp(
    String phoneNumber,
    String otp,
  ) async {
    try {
      final user = await remoteDataSource.verifyOtp(phoneNumber, otp);
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> createProfile({
    required String userId,
    required String name,
    String? username,
    String? bio,
    String? avatarUrl,
  }) async {
    try {
      final user = await remoteDataSource.createProfile(
        userId: userId,
        name: name,
        username: username,
        bio: bio,
        avatarUrl: avatarUrl,
      );
      await localDataSource.cacheUser(user);
      return Right(user);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCachedUser();
      return Right(user);
    } catch (e) {
      try {
        final user = await remoteDataSource.getCurrentUser();
        await localDataSource.cacheUser(user);
        return Right(user);
      } catch (e) {
        return Left(AuthenticationFailure('Not authenticated'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
