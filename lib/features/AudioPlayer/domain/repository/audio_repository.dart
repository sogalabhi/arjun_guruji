import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';
import 'package:dartz/dartz.dart';

abstract class AudioRepository {
  Future<Either<String, List<CategoryEntity>>> fetchCategoriesWithAudios();
}