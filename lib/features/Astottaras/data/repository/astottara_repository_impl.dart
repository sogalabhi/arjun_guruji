import 'package:arjun_guruji/features/Astottaras/data/datasource/ast_remote_ds.dart';
import 'package:arjun_guruji/features/Astottaras/data/model/astottara_model.dart';
import 'package:arjun_guruji/features/Astottaras/domain/entity/astottara.dart';
import 'package:arjun_guruji/features/Astottaras/domain/repository/astottaras_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:arjun_guruji/core/services/connectivity_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';

class AstottarasRepositoryImpl implements AstottaraRepository {
  final AstottarasRemoteDataSource remoteDataSource;
  const AstottarasRepositoryImpl({required this.remoteDataSource});

  Future<Uint8List?> downloadBytes(String url) async {
    try {
      final response = await Dio()
          .get(url, options: Options(responseType: ResponseType.bytes));
      return Uint8List.fromList(response.data);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<Either<String, List<Astottara>>> fetchAllAstottaras() async {
    try {
      final box = Hive.box<AstottaraModel>('astottarasBox');
      if (!ConnectivityService.isOnline.value) {
        // Offline: load from Hive
        final cachedAstottaras = box.values.toList();
        if (cachedAstottaras.isEmpty) {
          return const Left('No internet and no cached astottaras available');
        }
        return Right(cachedAstottaras
            .map((model) => AstottaraModel.toEntity(model))
            .toList());
      }
      // Check local vs remote count
      final localCount = box.length;
      final firestore = FirebaseFirestore.instance;
      final remoteCount =
          (await firestore.collection('Astottaras').get()).docs.length;
      if (localCount == remoteCount && localCount > 0) {
        print('Astottaras: Local and remote counts match, loading from cache.');
        final cachedAstottaras = box.values.toList();
        return Right(cachedAstottaras
            .map((model) => AstottaraModel.toEntity(model))
            .toList());
      }
      print('Astottaras: Syncing from remote...');
      final astottaras = await remoteDataSource.fetchAllAstottaras();
      if (astottaras.isEmpty) {
        return const Left('Astottaras Are Empty');
      }
      await box.clear();
      for (final model in astottaras) {
        Uint8List? imageBytes = model.imageBytes;
        if ((imageBytes == null || imageBytes.isEmpty) &&
            model.imageUrl.isNotEmpty) {
          imageBytes = await downloadBytes(model.imageUrl);
        }
        final updatedModel = AstottaraModel(
          title: model.title,
          imageUrl: model.imageUrl,
          content: model.content,
          imageBytes: imageBytes,
        );
        await box.put(model.title, updatedModel);
      }
      return Right(
          box.values.map((model) => AstottaraModel.toEntity(model)).toList());
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }
}
