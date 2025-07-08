import 'package:arjun_guruji/features/Books/data/datasource/books_remote_ds.dart';
import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:arjun_guruji/features/Books/domain/repository/books_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:arjun_guruji/core/services/connectivity_service.dart';

Future<Uint8List?> downloadBytes(String url) async {
  try {
    final response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(response.data);
  } catch (_) {
    return null;
  }
}

class BooksRepositoryImpl implements BookRepository {
  final BooksRemoteDataSource remoteDataSource;
  const BooksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<Book>>> fetchAllBooks() async {
    try {
      final box = Hive.box<BookModel>('booksBox');
      if (!ConnectivityService.isOnline.value) {
        // Offline: load from Hive
        final cachedBooks = box.values.toList();
        if (cachedBooks.isEmpty) {
          return const Left('No internet and no cached books available');
        }
        return Right(cachedBooks.map((bookModel) => BookModel.toEntity(bookModel)).toList());
      }
      final books = await remoteDataSource.fetchAllBooks();
      if (books.isEmpty) {
        return const Left('Books Are Empty');
      }
      List<BookModel> updatedBooks = [];
      for (final book in books) {
        // Check if already cached
        final cached = box.get(book.title);
        Uint8List? pdfBytes = cached?.pdfBytes;
        Uint8List? imageBytes = cached?.imageBytes;
        // Download if not cached
        if (pdfBytes == null && book.content != null && book.content!.isNotEmpty) {
          pdfBytes = await downloadBytes(book.content!);
        }
        if (imageBytes == null && book.imageUrl.isNotEmpty) {
          imageBytes = await downloadBytes(book.imageUrl);
        }
        final updatedBook = BookModel(
          title: book.title,
          imageUrl: book.imageUrl,
          bookType: book.bookType,
          content: book.content,
          chapters: book.chapters,
          pdfBytes: pdfBytes,
          imageBytes: imageBytes,
        );
        await box.put(book.title, updatedBook);
        updatedBooks.add(updatedBook);
      }
      return Right(updatedBooks.map((bookModel) => BookModel.toEntity(bookModel)).toList());
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }
}
