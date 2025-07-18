import 'dart:typed_data';

class Lyrics {
  final String docId;
  final String title;
  final String category;
  final String? content;
  final String? imageUrl;
  final Uint8List? imageBytes;

  Lyrics({
    required this.docId,
    required this.title,
    required this.category,
    this.content,
    this.imageUrl,
    this.imageBytes,
  });
}
