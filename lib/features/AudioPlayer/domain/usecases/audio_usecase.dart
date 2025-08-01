import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/repository/audio_repository.dart';
import 'package:dartz/dartz.dart';

class FetchAudioUseCase
    implements Usecase<List<CategoryEntity>, NoParams, String> {
  final AudioRepository audioRepository;

  FetchAudioUseCase(this.audioRepository);

  @override
  Future<Either<String, List<CategoryEntity>>> call(NoParams params) async {
    var res = await audioRepository.fetchCategoriesWithAudios();
    return res;
  }
}
