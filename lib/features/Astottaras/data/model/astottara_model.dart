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

  AstottaraModel({
    required this.title,
    required this.imageUrl,
    this.content,
    this.imageBytes,
  });

  factory AstottaraModel.fromJson(Map<String, dynamic> json) {
    return AstottaraModel(
      title: json['title'],
      imageUrl: json['imageUrl'],
      content: json['content'],
      imageBytes: json['imageBytes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'content': content,
      'imageBytes': imageBytes,
    };
  }

  static AstottaraModel fromEntity(Astottara astottara) {
    return AstottaraModel(
      title: astottara.title,
      imageUrl: astottara.imageUrl,
      content: astottara.content,
      imageBytes: astottara.imageBytes,
    );
  }

  static Astottara toEntity(AstottaraModel astottaraModel) {
    return Astottara(
      title: astottaraModel.title,
      imageUrl: astottaraModel.imageUrl,
      content: astottaraModel.content,
      imageBytes: astottaraModel.imageBytes,
    );
  }
}
