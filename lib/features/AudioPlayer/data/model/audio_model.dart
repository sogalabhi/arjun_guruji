import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';

class AudioModel extends AudioEntity {
  AudioModel({
    required String id,
    required String title,
    required String audioUrl,
    required String imageUrl,
    required String lyrics,
    required String category,
  }) : super(
          id: id,
          title: title,
          audioUrl: audioUrl,
          imageUrl: imageUrl,
          lyrics: lyrics,
          category: category,
        );

  // Convert JSON to AudioModel
  factory AudioModel.fromJson(String id, Map<String, dynamic> json) {
    return AudioModel(
      id: id,
      title: json['title'] ?? '',
      audioUrl: json['audioUrl'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      lyrics: json['lyrics'] ?? '',
      category: json['category'] ?? '',
    );
  }

  // Convert AudioModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'lyrics': lyrics,
      'category': category,
    };
  }
}
