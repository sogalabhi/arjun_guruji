import 'package:arjun_guruji/features/AudioPlayer/data/datasource/audio_remote_datasource.dart';
import 'package:arjun_guruji/features/AudioPlayer/data/model/category_model.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/repository/audio_repository.dart';
import 'package:dartz/dartz.dart';

class AudioRepositoryImpl implements AudioRepository {
  final AudioRemoteDataSource remoteDataSource;
  const AudioRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<CategoryModel>>>
      fetchCategoriesWithAudios() async {
    try {
      final audios = await remoteDataSource.fetchCategoriesWithAudios();
      if (audios.isEmpty) {
        return const Left('Audios Are Empty');
      }
      return Right(audios);
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }
}
