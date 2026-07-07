import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/settings_entity.dart';
import '../repository/settings_repository.dart';

class SaveSettingsUseCase implements Usecase<void, SettingsEntity, String> {
  final SettingsRepository repository;

  SaveSettingsUseCase(this.repository);

  @override
  Future<Either<String, void>> call(SettingsEntity params) async {
    return await repository.saveSettings(params);
  }
}
