import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/auth_repository.dart';

class SendOtp implements UseCase<void, SendOtpParams> {
  final AuthRepository repository;

  SendOtp(this.repository);

  @override
  Future<Either<Failure, void>> call(SendOtpParams params) async {
    return await repository.sendOtp(params.phoneNumber);
  }
}

class SendOtpParams {
  final String phoneNumber;

  SendOtpParams({required this.phoneNumber});
}
