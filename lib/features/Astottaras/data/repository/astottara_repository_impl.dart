import 'package:arjun_guruji/features/Astottaras/data/datasource/ast_remote_ds.dart';
import 'package:arjun_guruji/features/Astottaras/data/model/astottara_model.dart';
import 'package:arjun_guruji/features/Astottaras/domain/entity/astottara.dart';
import 'package:arjun_guruji/features/Astottaras/domain/repository/astottaras_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:arjun_guruji/core/services/connectivity_service.dart';

class AstottarasRepositoryImpl implements AstottaraRepository {
  final AstottarasRemoteDataSource remoteDataSource;
  const AstottarasRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<Astottara>>> fetchAllAstottaras() async {
    try {
      if (!ConnectivityService.isOnline.value) {
        // Offline: load from Hive
        return const Left('Offline mode');
      }
      final astottaras = await remoteDataSource.fetchAllAstottaras();
      if (astottaras.isEmpty) {
        return const Left('Astottaras Are Empty');
      }
      return Right(
          astottaras.map((astottaraModel) => AstottaraModel.toEntity(astottaraModel)).toList());
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }
}
