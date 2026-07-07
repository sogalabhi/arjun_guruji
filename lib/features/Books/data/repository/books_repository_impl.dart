import 'package:arjun_guruji/features/Books/data/datasource/books_remote_ds.dart';
import 'package:arjun_guruji/features/Books/data/datasource/books_local_ds.dart';
import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:arjun_guruji/features/Books/domain/repository/books_repository.dart';
import 'package:dartz/dartz.dart';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:arjun_guruji/core/services/connectivity_service.dart';

Future<Uint8List?> _downloadBytes(String url) async {
  try {
    final response = await Dio()
        .get(url, options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(response.data);
  } catch (_) {
    return null;
  }
}

class BooksRepositoryImpl implements BookRepository {
  final BooksRemoteDataSource remoteDataSource;
  final BooksLocalDataSource localDataSource;

  const BooksRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, List<Book>>> fetchAllBooks() async {
    try {
      final cachedBooks = localDataSource.getCachedBooks();

      if (!ConnectivityService.isOnline.value) {
        // Offline: load from Hive cache
        if (cachedBooks.isEmpty) {
          return const Left('No internet and no cached books available');
        }
        return Right(cachedBooks
            .map((bookModel) => BookModel.toEntity(bookModel))
            .toList());
      }

      // Build cache map for quick lookups
      final existingCache = <String, BookModel>{};
      for (final book in cachedBooks) {
        existingCache[book.title] = book;
      }

      // Fetch remote timestamps from Firestore
      List<Map<String, dynamic>> remoteTimestamps;
      try {
        remoteTimestamps = await remoteDataSource.fetchBookTimestamps();
      } catch (e) {
        // Fallback to cache if remote timestamps fail to load
        if (cachedBooks.isNotEmpty) {
          return Right(cachedBooks.map((b) => BookModel.toEntity(b)).toList());
        }
        return Left('Failed to fetch remote timestamps: $e');
      }

      // Determine if sync is needed (additions, deletions, updates)
      bool needsSync = false;
      final remoteTitles = remoteTimestamps.map((m) => m['title'] as String).toSet();

      // Check for deletions
      for (final cachedTitle in existingCache.keys) {
        if (!remoteTitles.contains(cachedTitle)) {
          needsSync = true;
          break;
        }
      }

      // Check for additions or updates
      if (!needsSync) {
        for (final remoteItem in remoteTimestamps) {
          final title = remoteItem['title'] as String;
          final remoteUpdated = remoteItem['lastUpdated'] as DateTime?;
          final cachedBook = existingCache[title];

          if (cachedBook == null) {
            needsSync = true;
            break;
          }

          if (remoteUpdated != null) {
            if (cachedBook.lastUpdated == null || remoteUpdated.isAfter(cachedBook.lastUpdated!)) {
              needsSync = true;
              break;
            }
          }
        }
      }

      // Check total count mismatch
      if (!needsSync && cachedBooks.length != remoteTimestamps.length) {
        needsSync = true;
      }

      if (!needsSync) {
        return Right(cachedBooks
            .map((bookModel) => BookModel.toEntity(bookModel))
            .toList());
      }

      final remoteBooks = await remoteDataSource.fetchAllBooks();
      if (remoteBooks.isEmpty) {
        await localDataSource.clearCache();
        return const Right([]);
      }

      // Download cover images in parallel and preserve cache fields
      final List<Future<BookModel>> downloadFutures = remoteBooks.map((remoteBook) async {
        final cached = existingCache[remoteBook.title];
        String? pdfFilePath = cached?.pdfFilePath;
        Uint8List? imageBytes = cached?.imageBytes;

        final hasImageChanged = cached == null || cached.imageUrl != remoteBook.imageUrl;
        if (imageBytes == null || imageBytes.isEmpty || hasImageChanged) {
          if (remoteBook.imageUrl.isNotEmpty) {
            imageBytes = await _downloadBytes(remoteBook.imageUrl);
          }
        }

        return BookModel(
          title: remoteBook.title,
          imageUrl: remoteBook.imageUrl,
          bookType: remoteBook.bookType,
          htmlContent: remoteBook.htmlContent,
          pdfUrl: remoteBook.pdfUrl,
          chapters: remoteBook.chapters,
          pdfFilePath: pdfFilePath,
          imageBytes: imageBytes,
          lastUpdated: remoteBook.lastUpdated,
        );
      }).toList();

      final List<BookModel> syncedBooks = await Future.wait(downloadFutures);

      // Save to local cache
      await localDataSource.cacheBooks(syncedBooks);

      return Right(syncedBooks
          .map((bookModel) => BookModel.toEntity(bookModel))
          .toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<Book>>> fetchBookSummaries() async {
    try {
      final books = await remoteDataSource.fetchBookSummaries();
      if (books.isEmpty) {
        return const Left('Books Are Empty');
      }
      return Right(
          books.map((bookModel) => BookModel.toEntity(bookModel)).toList());
    } catch (e) {
      return Left(e.toString());
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
      return Left(e.toString());
    }
  }

  @override
  List<Book> getCachedBooks() {
    return localDataSource.getCachedBooks()
        .map((bookModel) => BookModel.toEntity(bookModel))
        .toList();
  }
}
