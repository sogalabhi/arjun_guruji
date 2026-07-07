import 'package:arjun_guruji/features/Astottaras/domain/entity/astottara.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'astottara_model.g.dart'; // Generated file

@HiveType(typeId: 1)
class AstottaraModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final String? content;

  @HiveField(3)
  final Uint8List? imageBytes;

  @HiveField(4)
  final DateTime? lastUpdated;

  AstottaraModel({
    required this.title,
    required this.imageUrl,
    this.content,
    this.imageBytes,
    this.lastUpdated,
  });

  factory AstottaraModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['lastUpdated'] is DateTime) {
      parsedDate = json['lastUpdated'] as DateTime;
    } else if (json['lastUpdated'] is String) {
      parsedDate = DateTime.tryParse(json['lastUpdated'] as String);
    }

    return AstottaraModel(
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      content: json['content'] as String?,
      imageBytes: json['imageBytes'] as Uint8List?,
      lastUpdated: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'content': content,
      'imageBytes': imageBytes,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  static AstottaraModel fromEntity(Astottara astottara) {
    return AstottaraModel(
      title: astottara.title,
      imageUrl: astottara.imageUrl,
      content: astottara.content,
      imageBytes: astottara.imageBytes,
      lastUpdated: astottara.lastUpdated,
    );
  }

  static Astottara toEntity(AstottaraModel astottaraModel) {
    return Astottara(
      title: astottaraModel.title,
      imageUrl: astottaraModel.imageUrl,
      content: astottaraModel.content,
      imageBytes: astottaraModel.imageBytes,
      lastUpdated: astottaraModel.lastUpdated,
    );
  }
}
