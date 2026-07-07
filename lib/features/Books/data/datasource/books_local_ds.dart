import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:hive/hive.dart';

abstract class BooksLocalDataSource {
  List<BookModel> getCachedBooks();
  Future<void> cacheBooks(List<BookModel> books);
  Future<void> clearCache();
  Future<void> saveBook(BookModel book);
  Future<void> updatePdfFilePath(String title, String path);
}

class BooksLocalDataSourceImpl implements BooksLocalDataSource {
  final Box<BookModel> booksBox;

  BooksLocalDataSourceImpl({required this.booksBox});

  @override
  List<BookModel> getCachedBooks() {
    return booksBox.values.toList();
  }

  @override
  Future<void> cacheBooks(List<BookModel> books) async {
    await booksBox.clear();
    for (final book in books) {
      await booksBox.put(book.title, book);
    }
  }

  @override
  Future<void> clearCache() async {
    await booksBox.clear();
  }

  @override
  Future<void> saveBook(BookModel book) async {
    await booksBox.put(book.title, book);
  }

  @override
  Future<void> updatePdfFilePath(String title, String path) async {
    final book = booksBox.get(title);
    if (book != null) {
      final updatedBook = BookModel(
        title: book.title,
        imageUrl: book.imageUrl,
        bookType: book.bookType,
        htmlContent: book.htmlContent,
        pdfUrl: book.pdfUrl,
        chapters: book.chapters,
        pdfFilePath: path,
        imageBytes: book.imageBytes,
        lastUpdated: book.lastUpdated,
      );
      await booksBox.put(title, updatedBook);
    }
  }
}
