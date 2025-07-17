import 'dart:typed_data';

class Book {
  final String title;
  final String imageUrl;
  final String bookType;
  final String? content;
  final List<Map<String, dynamic>>? chapters;
  final String? pdfFilePath;
  final Uint8List? imageBytes;

  Book({
    required this.title,
    required this.imageUrl,
    required this.bookType,
    this.content,
    this.chapters,
    this.pdfFilePath,
    this.imageBytes,
  });
}
