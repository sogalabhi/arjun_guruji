import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';

class CategoryEntity {
  final String id;
  final String name;
  final String imageUrl;
  final List<AudioEntity> audios;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.audios,
  });
}
