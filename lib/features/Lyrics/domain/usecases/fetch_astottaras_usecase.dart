import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/Astottaras/domain/entity/astottara.dart';
import 'package:arjun_guruji/features/Astottaras/domain/repository/astottaras_repository.dart';
import 'package:dartz/dartz.dart';

class FetchAstottarasUseCase implements Usecase<List<Astottara>, NoParams, String> {
  final AstottaraRepository astottaraRepository;

  FetchAstottarasUseCase(this.astottaraRepository);

  @override
  Future<Either<String, List<Astottara>>> call(NoParams params) async {
    var res = await astottaraRepository.fetchAllAstottaras();
    print('res in usecase: $res');
    return res;
  }
}
