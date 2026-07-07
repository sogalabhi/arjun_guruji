import 'package:dartz/dartz.dart';
import '../../domain/entity/settings_entity.dart';
import '../../domain/repository/settings_repository.dart';
import '../datasource/settings_local_ds.dart';
import '../model/settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl(this.localDataSource);

  @override
  Future<Either<String, SettingsEntity>> getSettings() async {
    try {
      final settingsModel = localDataSource.getSettings();
      return Right(settingsModel);
    } catch (e) {
      return Left('Failed to load settings: $e');
    }
  }

  @override
  Future<Either<String, void>> saveSettings(SettingsEntity settings) async {
    try {
      final settingsModel = SettingsModel.fromEntity(settings);
      await localDataSource.saveSettings(settingsModel);
      return const Right(null);
    } catch (e) {
      return Left('Failed to save settings: $e');
    }
  }
}
