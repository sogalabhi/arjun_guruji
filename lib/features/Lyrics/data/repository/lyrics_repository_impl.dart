import 'package:arjun_guruji/features/Lyrics/data/datasource/lyrics_remote_datastructure.dart';
import 'package:arjun_guruji/features/Lyrics/data/model/lyrics_model.dart';
import 'package:arjun_guruji/features/Lyrics/domain/entity/lyrics.dart';
import 'package:arjun_guruji/features/Lyrics/domain/repository/lyrics_repository.dart';
import 'package:dartz/dartz.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';

class LyricsRepositoryImpl implements LyricsRepository {
  final LyricsRemoteDataSource remoteDataSource;
  const LyricsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<Lyrics>>> fetchAllLyrics() async {
    try {
      final box = Hive.box<LyricsModel>('lyricsBox');
      final lyrics = await remoteDataSource.fetchAllLyrics();
      if (lyrics.isEmpty) {
        return const Left('Lyrics Are Empty');
      }
      await box.clear();
      for (final model in lyrics) {
        Uint8List? imageBytes = model.imageBytes;
        if ((imageBytes == null || imageBytes.isEmpty) &&
            model.imageUrl != null &&
            model.imageUrl!.isNotEmpty) {
          try {
            final response = await Dio().get(model.imageUrl!,
                options: Options(responseType: ResponseType.bytes));
            imageBytes = Uint8List.fromList(response.data);
          } catch (_) {
            imageBytes = null;
          }
        }
        final updatedModel = LyricsModel(
          docId: model.docId,
          title: model.title,
          category: model.category,
          content: model.content,
          imageUrl: model.imageUrl,
          imageBytes: imageBytes,
        );
        await box.put(model.docId, updatedModel);
      }
      return Right(
          box.values.map((model) => LyricsModel.toEntity(model)).toList());
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }
}
