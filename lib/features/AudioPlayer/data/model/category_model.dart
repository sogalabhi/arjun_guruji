import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';
import '../../domain/entity/category.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.id,
    required super.name,
    required super.imageUrl,
    required super.audios,
  });

  // Convert JSON to CategoryModel
  factory CategoryModel.fromJson(
      String id, Map<String, dynamic> json, List<AudioEntity> audios) {
    return CategoryModel(
      id: id,
      name: json['name'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      audios: audios,
    );
  }

  // Convert CategoryModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'imageUrl': imageUrl,
    };
  }
}
