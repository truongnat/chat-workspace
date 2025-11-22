import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class VerifyOtp implements UseCase<User, VerifyOtpParams> {
  final AuthRepository repository;

  VerifyOtp(this.repository);

  @override
  Future<Either<Failure, User>> call(VerifyOtpParams params) async {
    return await repository.verifyOtp(params.phoneNumber, params.otp);
  }
}

class VerifyOtpParams {
  final String phoneNumber;
  final String otp;

  VerifyOtpParams({
    required this.phoneNumber,
    required this.otp,
  });
}
