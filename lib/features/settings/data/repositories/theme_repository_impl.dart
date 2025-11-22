import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/app_theme_data.dart';
import '../../domain/repositories/theme_repository.dart';
import '../datasources/theme_local_datasource.dart';
import '../models/app_theme_data_model.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDataSource localDataSource;

  ThemeRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, AppThemeData>> getTheme() async {
    try {
      final theme = await localDataSource.getTheme();
      return Right(theme);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> saveTheme(AppThemeData theme) async {
    try {
      final model = AppThemeDataModel.fromEntity(theme);
      await localDataSource.saveTheme(model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetToDefault() async {
    try {
      await localDataSource.clearTheme();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
