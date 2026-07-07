import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';

part 'book_model.g.dart'; // Generated file

@HiveType(typeId: 0)
class BookModel extends HiveObject {
  @HiveField(0)
  final String title;

  @HiveField(1)
  final String imageUrl;

  @HiveField(2)
  final String bookType;

  @HiveField(3)
  final String? htmlContent;

  @HiveField(4)
  final List<Map<String, dynamic>>? chapters;

  @HiveField(5)
  final String? pdfFilePath;

  @HiveField(6)
  final Uint8List? imageBytes;

  @HiveField(7)
  final DateTime? lastUpdated;

  @HiveField(8)
  final String? pdfUrl;

  BookModel({
    required this.title,
    required this.imageUrl,
    required this.bookType,
    String? htmlContent,
    String? pdfUrl,
    this.chapters,
    this.pdfFilePath,
    this.imageBytes,
    this.lastUpdated,
  })  : htmlContent = bookType == 'html' ? (htmlContent ?? pdfUrl) : null,
        pdfUrl = bookType != 'html' && bookType != 'chapters' ? (pdfUrl ?? htmlContent) : null;

  factory BookModel.fromJson(Map<String, dynamic> json) {
    DateTime? parsedDate;
    if (json['lastUpdated'] is DateTime) {
      parsedDate = json['lastUpdated'] as DateTime;
    } else if (json['lastUpdated'] is String) {
      parsedDate = DateTime.tryParse(json['lastUpdated'] as String);
    }
    
    final String bookType = json['bookType'] ?? '';
    final String? contentStr = json['content'] as String?;
    final String? htmlContent = bookType == 'html' ? contentStr : null;
    final String? pdfUrl = (bookType != 'html' && bookType != 'chapters') ? contentStr : null;

    return BookModel(
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      bookType: bookType,
      htmlContent: htmlContent,
      pdfUrl: pdfUrl,
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((chapter) => {
                    'chapterName': chapter['chapterName'] as String? ?? '',
                    'content': chapter['content'] as String? ?? '',
                  })
              .toList() ??
          [],
      pdfFilePath: json['pdfFilePath'] as String?,
      imageBytes: json['imageBytes'] as Uint8List?,
      lastUpdated: parsedDate,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'bookType': bookType,
      'content': bookType == 'html' ? htmlContent : pdfUrl,
      'chapters': chapters,
      'pdfFilePath': pdfFilePath,
      'imageBytes': imageBytes,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  static BookModel fromEntity(Book book) {
    return BookModel(
      title: book.title,
      imageUrl: book.imageUrl,
      bookType: book.bookType,
      htmlContent: book.htmlContent,
      pdfUrl: book.pdfUrl,
      chapters: book.chapters,
      pdfFilePath: book.pdfFilePath,
      imageBytes: book.imageBytes,
      lastUpdated: book.lastUpdated,
    );
  }

  static Book toEntity(BookModel bookModel) {
    return Book(
      title: bookModel.title,
      imageUrl: bookModel.imageUrl,
      bookType: bookModel.bookType,
      htmlContent: bookModel.htmlContent,
      pdfUrl: bookModel.pdfUrl,
      chapters: bookModel.chapters,
      pdfFilePath: bookModel.pdfFilePath,
      imageBytes: bookModel.imageBytes,
      lastUpdated: bookModel.lastUpdated,
    );
  }
}
