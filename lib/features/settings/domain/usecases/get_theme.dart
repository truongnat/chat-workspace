import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_theme_data.dart';
import '../repositories/theme_repository.dart';

class GetTheme implements UseCase<AppThemeData, NoParams> {
  final ThemeRepository repository;

  GetTheme(this.repository);

  @override
  Future<Either<Failure, AppThemeData>> call(NoParams params) async {
    return await repository.getTheme();
  }
}
