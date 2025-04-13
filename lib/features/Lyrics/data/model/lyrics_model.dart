import 'package:arjun_guruji/features/Lyrics/domain/entity/lyrics.dart';
import 'package:hive/hive.dart';

part 'lyrics_model.g.dart'; // Generated file

@HiveType(typeId: 3)
class LyricsModel extends HiveObject  {
  @HiveField(0)
  final String docId;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String category;

  @HiveField(3)
  final String? content;

  LyricsModel({
    required this.docId,
    required this.title,
    required this.category,
    this.content,
  });

  factory LyricsModel.fromJson(Map<String, dynamic> json) {
    return LyricsModel(
      docId: json['docId'],
      title: json['title'],
      category: json['category'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'docId': docId,
      'title': title,
      'category': category,
      'content': content,
    };
  }

  static LyricsModel fromEntity(Lyrics lyrics) {
    return LyricsModel(
      docId: lyrics.docId,
      title: lyrics.title,
      category: lyrics.category,
      content: lyrics.content,
    );
  }

  static Lyrics toEntity(LyricsModel lyricsModel) {
    return Lyrics(
      docId: lyricsModel.docId,
      title: lyricsModel.title,
      category: lyricsModel.category,
      content: lyricsModel.content,
    );
  }
}
