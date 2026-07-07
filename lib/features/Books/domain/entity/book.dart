import 'dart:typed_data';

class Book {
  final String title;
  final String imageUrl;
  final String bookType;
  final String? htmlContent;
  final String? pdfUrl;
  final List<Map<String, dynamic>>? chapters;
  final String? pdfFilePath;
  final Uint8List? imageBytes;
  final DateTime? lastUpdated;

  Book({
    required this.title,
    required this.imageUrl,
    required this.bookType,
    this.htmlContent,
    this.pdfUrl,
    this.chapters,
    this.pdfFilePath,
    this.imageBytes,
    this.lastUpdated,
  });
}
