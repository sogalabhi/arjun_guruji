import 'package:dartz/dartz.dart';
import '../entity/settings_entity.dart';

abstract class SettingsRepository {
  Future<Either<String, SettingsEntity>> getSettings();
  Future<Either<String, void>> saveSettings(SettingsEntity settings);
}
