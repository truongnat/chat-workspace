import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/app_theme_data.dart';
import '../repositories/theme_repository.dart';

class SaveTheme implements UseCase<void, SaveThemeParams> {
  final ThemeRepository repository;

  SaveTheme(this.repository);

  @override
  Future<Either<Failure, void>> call(SaveThemeParams params) async {
    return await repository.saveTheme(params.theme);
  }
}

class SaveThemeParams {
  final AppThemeData theme;

  SaveThemeParams({required this.theme});
}
