import 'package:arjun_guruji/features/Lyrics/domain/entity/lyrics.dart';
import 'package:dartz/dartz.dart';

abstract class LyricsRepository {
  Future<Either<String, List<Lyrics>>> fetchAllLyrics();
}
