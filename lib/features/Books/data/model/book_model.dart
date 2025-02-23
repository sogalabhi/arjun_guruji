import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:hive/hive.dart';

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

  BookModel({
    required this.title,
    required this.imageUrl,
    required this.bookType,
    this.content,
    this.chapters,
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
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'imageUrl': imageUrl,
      'bookType': bookType,
      'content': content,
      'chapters': chapters,
    };
  }

  static BookModel fromEntity(Book book) {
    return BookModel(
      title: book.title,
      imageUrl: book.imageUrl,
      bookType: book.bookType,
      content: book.content,
      chapters: book.chapters,
    );
  }

  static Book toEntity(BookModel bookModel) {
    return Book(
      title: bookModel.title,
      imageUrl: bookModel.imageUrl,
      bookType: bookModel.bookType,
      content: bookModel.content,
      chapters: bookModel.chapters,
    );
  }
}