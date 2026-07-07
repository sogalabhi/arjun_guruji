import 'package:arjun_guruji/features/Astottaras/data/datasource/ast_remote_ds.dart';
import 'package:arjun_guruji/features/Astottaras/data/datasource/ast_local_ds.dart';
import 'package:arjun_guruji/features/Astottaras/data/model/astottara_model.dart';
import 'package:arjun_guruji/features/Astottaras/domain/entity/astottara.dart';
import 'package:arjun_guruji/features/Astottaras/domain/repository/astottaras_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:arjun_guruji/core/services/connectivity_service.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';

Future<Uint8List?> _downloadBytes(String url) async {
  try {
    final response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(response.data);
  } catch (_) {
    return null;
  }
}

class AstottarasRepositoryImpl implements AstottaraRepository {
  final AstottarasRemoteDataSource remoteDataSource;
  final AstottarasLocalDataSource localDataSource;

  const AstottarasRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, List<Astottara>>> fetchAllAstottaras() async {
    try {
      final cachedAstottaras = localDataSource.getCachedAstottaras();

      if (!ConnectivityService.isOnline.value) {
        // Offline: load from cache
        if (cachedAstottaras.isEmpty) {
          return const Left('No internet and no cached astottaras available');
        }
        return Right(cachedAstottaras
            .map((model) => AstottaraModel.toEntity(model))
            .toList());
      }

      // Build cache map for quick lookups
      final existingCache = <String, AstottaraModel>{};
      for (final ast in cachedAstottaras) {
        existingCache[ast.title] = ast;
      }

      // Fetch remote timestamps from Firestore
      List<Map<String, dynamic>> remoteTimestamps;
      try {
        remoteTimestamps = await remoteDataSource.fetchAstottaraTimestamps();
      } catch (e) {
        // Fallback to cache if remote timestamps fail to load
        if (cachedAstottaras.isNotEmpty) {
          return Right(cachedAstottaras.map((a) => AstottaraModel.toEntity(a)).toList());
        }
        return Left('Failed to fetch remote timestamps: $e');
      }

      // Determine if sync is needed (additions, deletions, updates)
      bool needsSync = false;
      final remoteTitles = remoteTimestamps.map((m) => m['title'] as String).toSet();

      // Check for deletions
      for (final cachedTitle in existingCache.keys) {
        if (!remoteTitles.contains(cachedTitle)) {
          needsSync = true;
          break;
        }
      }

      // Check for additions or updates
      if (!needsSync) {
        for (final remoteItem in remoteTimestamps) {
          final title = remoteItem['title'] as String;
          final remoteUpdated = remoteItem['lastUpdated'] as DateTime?;
          final cachedAst = existingCache[title];

          if (cachedAst == null) {
            needsSync = true;
            break;
          }

          if (remoteUpdated != null) {
            if (cachedAst.lastUpdated == null || remoteUpdated.isAfter(cachedAst.lastUpdated!)) {
              needsSync = true;
              break;
            }
          }
        }
      }

      // Check total count mismatch
      if (!needsSync && cachedAstottaras.length != remoteTimestamps.length) {
        needsSync = true;
      }

      if (!needsSync) {
        return Right(cachedAstottaras
            .map((model) => AstottaraModel.toEntity(model))
            .toList());
      }

      final remoteAstottaras = await remoteDataSource.fetchAllAstottaras();
      if (remoteAstottaras.isEmpty) {
        await localDataSource.clearCache();
        return const Right([]);
      }

      // Download cover images in parallel and preserve cache fields
      final List<Future<AstottaraModel>> downloadFutures = remoteAstottaras.map((remoteItem) async {
        final cached = existingCache[remoteItem.title];
        Uint8List? imageBytes = cached?.imageBytes;

        final hasImageChanged = cached == null || cached.imageUrl != remoteItem.imageUrl;
        if (imageBytes == null || imageBytes.isEmpty || hasImageChanged) {
          if (remoteItem.imageUrl.isNotEmpty) {
            imageBytes = await _downloadBytes(remoteItem.imageUrl);
          }
        }

        return AstottaraModel(
          title: remoteItem.title,
          imageUrl: remoteItem.imageUrl,
          content: remoteItem.content,
          imageBytes: imageBytes,
          lastUpdated: remoteItem.lastUpdated,
        );
      }).toList();

      final List<AstottaraModel> syncedAstottaras = await Future.wait(downloadFutures);

      // Save to local cache
      await localDataSource.cacheAstottaras(syncedAstottaras);

      return Right(syncedAstottaras
          .map((model) => AstottaraModel.toEntity(model))
          .toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  List<Astottara> getCachedAstottaras() {
    return localDataSource.getCachedAstottaras()
        .map((model) => AstottaraModel.toEntity(model))
        .toList();
  }
}
