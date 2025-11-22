import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CreateProfile implements UseCase<User, CreateProfileParams> {
  final AuthRepository repository;

  CreateProfile(this.repository);

  @override
  Future<Either<Failure, User>> call(CreateProfileParams params) async {
    return await repository.createProfile(
      userId: params.userId,
      name: params.name,
      username: params.username,
      bio: params.bio,
      avatarUrl: params.avatarUrl,
    );
  }
}

class CreateProfileParams {
  final String userId;
  final String name;
  final String? username;
  final String? bio;
  final String? avatarUrl;

  CreateProfileParams({
    required this.userId,
    required this.name,
    this.username,
    this.bio,
    this.avatarUrl,
  });
}
