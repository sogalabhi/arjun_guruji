import 'dart:typed_data';

class Astottara {
  final String title;
  final String imageUrl;
  final String? content;
  final Uint8List? imageBytes;

  Astottara({
    required this.title,
    required this.imageUrl,
    this.content,
    this.imageBytes,
  });
}
