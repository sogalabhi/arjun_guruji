import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';

class CategoryEntity {
  String id;
  String name;
  String imageUrl;
  List<AudioEntity> audios;

  CategoryEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.audios,
  });
}
