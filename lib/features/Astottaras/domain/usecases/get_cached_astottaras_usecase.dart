import 'package:arjun_guruji/features/Astottaras/domain/entity/astottara.dart';
import 'package:arjun_guruji/features/Astottaras/domain/repository/astottaras_repository.dart';

class GetCachedAstottarasUseCase {
  final AstottaraRepository repository;
  GetCachedAstottarasUseCase(this.repository);

  List<Astottara> call() {
    return repository.getCachedAstottaras();
  }
}
