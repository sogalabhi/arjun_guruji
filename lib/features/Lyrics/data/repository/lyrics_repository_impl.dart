import 'package:arjun_guruji/features/Lyrics/data/datasource/lyrics_remote_datastructure.dart';
import 'package:arjun_guruji/features/Lyrics/data/model/lyrics_model.dart';
import 'package:arjun_guruji/features/Lyrics/domain/entity/lyrics.dart';
import 'package:arjun_guruji/features/Lyrics/domain/repository/lyrics_repository.dart';
import 'package:dartz/dartz.dart';

class LyricsRepositoryImpl implements LyricsRepository {
  final LyricsRemoteDataSource remoteDataSource;
  const LyricsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<Lyrics>>> fetchAllLyrics() async {
    try {
      final lyrics = await remoteDataSource.fetchAllLyrics();
      if (lyrics.isEmpty) {
        return const Left('Lyrics Are Empty');
      }
      return Right(lyrics.map((e) => LyricsModel.toEntity(e)).toList());
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }
}
