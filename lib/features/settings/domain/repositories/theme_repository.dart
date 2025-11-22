import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/app_theme_data.dart';

abstract class ThemeRepository {
  Future<Either<Failure, AppThemeData>> getTheme();
  Future<Either<Failure, void>> saveTheme(AppThemeData theme);
  Future<Either<Failure, void>> resetToDefault();
}
