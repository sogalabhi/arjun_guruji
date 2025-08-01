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
  final String? content;

  @HiveField(4)
  final List<Map<String, dynamic>>? chapters;

  @HiveField(5)
  final String? pdfFilePath;

  @HiveField(6)
  final Uint8List? imageBytes;

  BookModel({
    required this.title,
    required this.imageUrl,
    required this.bookType,
    this.content,
    this.chapters,
    this.pdfFilePath,
    this.imageBytes,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'],
      imageUrl: json['imageUrl'],
      bookType: json['bookType'],
      content: json['content'],
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((chapter) => {
                    'chapterName': chapter['chapterName'] as String? ?? '',
                    'content': chapter['content'] as String? ?? '',
                  })
              .toList() ??
          [],
      pdfFilePath: json['pdfFilePath'] as String?,
      imageBytes: json['imageBytes'] as Uint8List?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'bookType': bookType,
      'content': content,
      'chapters': chapters,
      'pdfFilePath': pdfFilePath,
      'imageBytes': imageBytes,
    };
  }

  static BookModel fromEntity(Book book) {
    return BookModel(
      title: book.title,
      imageUrl: book.imageUrl,
      bookType: book.bookType,
      content: book.content,
      chapters: book.chapters,
      pdfFilePath: book.pdfFilePath,
      imageBytes: book.imageBytes,
    );
  }

  static Book toEntity(BookModel bookModel) {
    return Book(
      title: bookModel.title,
      imageUrl: bookModel.imageUrl,
      bookType: bookModel.bookType,
      content: bookModel.content,
      chapters: bookModel.chapters,
      pdfFilePath: bookModel.pdfFilePath,
      imageBytes: bookModel.imageBytes,
    );
  }
}
