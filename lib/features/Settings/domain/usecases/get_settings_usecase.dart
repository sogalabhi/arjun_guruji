import 'package:dartz/dartz.dart';
import '../../../../core/usecases/usecase.dart';
import '../entity/settings_entity.dart';
import '../repository/settings_repository.dart';

class GetSettingsUseCase implements Usecase<SettingsEntity, NoParams, String> {
  final SettingsRepository repository;

  GetSettingsUseCase(this.repository);

  @override
  Future<Either<String, SettingsEntity>> call(NoParams params) async {
    return await repository.getSettings();
  }
}
