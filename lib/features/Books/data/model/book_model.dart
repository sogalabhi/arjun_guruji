import 'package:arjun_guruji/features/Books/domain/entity/book.dart';

class BookModel extends Book {
  BookModel({
    required String title,
    required String imageUrl,
    required String bookType,
    String? content,
    List<Map<String, dynamic>>? chapters,
  }) : super(
          title: title,
          imageUrl: imageUrl,
          bookType: bookType,
          content: content,
          chapters: chapters,
        );

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
