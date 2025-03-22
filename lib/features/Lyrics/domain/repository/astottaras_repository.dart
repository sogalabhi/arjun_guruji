import 'package:arjun_guruji/features/Astottaras/domain/entity/astottara.dart';
import 'package:dartz/dartz.dart';

abstract class AstottaraRepository {
  Future<Either<String, List<Astottara>>> fetchAllAstottaras();
}
