import 'package:arjun_guruji/features/Books/data/datasource/books_remote_ds.dart';
import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:arjun_guruji/features/Books/domain/repository/books_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:arjun_guruji/core/services/connectivity_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<Uint8List?> downloadBytes(String url) async {
  try {
    final response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(response.data);
  } catch (_) {
    return null;
  }
}

Future<String?> downloadAndSavePdfFile(String url, String fileName) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final filePath = '${dir.path}/$fileName';
    await Dio().download(url, filePath);
    return filePath;
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
      await box.clear();
      for (final book in books) {
        final cached = box.get(book.title);
        String? pdfFilePath = cached?.pdfFilePath; // Keep existing if present
        Uint8List? imageBytes = cached?.imageBytes;
        final updatedBook = BookModel(
          title: book.title,
          imageUrl: book.imageUrl,
          bookType: book.bookType,
          content: book.content,
          chapters: book.chapters,
          pdfFilePath: pdfFilePath,
          imageBytes: imageBytes,
        );
        await box.put(book.title, updatedBook);
        updatedBooks.add(updatedBook);
      }
      // Start background cache update for missing images
      Future.microtask(() async {
        for (final book in books) {
          final cached = box.get(book.title);
          if ((cached?.imageBytes == null || cached!.imageBytes!.isEmpty) && book.imageUrl.isNotEmpty) {
            final imageBytes = await downloadBytes(book.imageUrl);
            if (imageBytes != null) {
              final updatedBook = BookModel(
                title: book.title,
                imageUrl: book.imageUrl,
                bookType: book.bookType,
                content: book.content,
                chapters: book.chapters,
                pdfFilePath: cached?.pdfFilePath,
                imageBytes: imageBytes,
              );
              await box.put(book.title, updatedBook);
            }
          }
        }
      });
      return Right(updatedBooks.map((bookModel) => BookModel.toEntity(bookModel)).toList());
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }

  @override
  Future<Either<String, List<Book>>> fetchBookSummaries() async {
    try {
      final books = await remoteDataSource.fetchBookSummaries();
      if (books.isEmpty) {
        return const Left('Books Are Empty');
      }
      return Right(books.map((bookModel) => BookModel.toEntity(bookModel)).toList());
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either<String, Book>> fetchBookDetailsByTitle(String title) async {
    try {
      final bookModel = await remoteDataSource.fetchBookDetailsByTitle(title);
      if (bookModel == null) {
        return const Left('Book not found');
      }
      return Right(BookModel.toEntity(bookModel));
    } catch (e) {
      return left(e.toString());
    }
  }
}
