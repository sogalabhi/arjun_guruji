import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/Lyrics/domain/entity/lyrics.dart';
import 'package:arjun_guruji/features/Lyrics/domain/repository/lyrics_repository.dart';
import 'package:dartz/dartz.dart';

class FetchLyricsUseCase implements Usecase<List<Lyrics>, NoParams, String> {
  final LyricsRepository lyricsRepository;

  FetchLyricsUseCase(this.lyricsRepository);

  @override
  Future<Either<String, List<Lyrics>>> call(NoParams params) async {
    var res = await lyricsRepository.fetchAllLyrics();
    print('res in usecase: $res');
    return res;
  }
}
