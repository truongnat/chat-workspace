import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, void>> sendOtp(String phoneNumber);
  Future<Either<Failure, User>> verifyOtp(String phoneNumber, String otp);
  Future<Either<Failure, User>> createProfile({
    required String userId,
    required String name,
    String? username,
    String? bio,
    String? avatarUrl,
  });
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, User>> getCurrentUser();
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, String?>> getUserPublicKey(String userId);
}
