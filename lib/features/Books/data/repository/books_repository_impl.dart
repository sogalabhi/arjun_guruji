import 'package:arjun_guruji/features/Books/data/datasource/books_remote_ds.dart';
import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:arjun_guruji/features/Books/domain/repository/books_repository.dart';
import 'package:dartz/dartz.dart';

class BooksRepositoryImpl implements BookRepository {
  final BooksRemoteDataSource remoteDataSource;
  const BooksRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<Book>>> fetchAllBooks() async {
    try {
      final books = await remoteDataSource.fetchAllBooks();
      if (books.isEmpty) {
        return const Left('Books Are Empty');
      }
      return Right(
          books.map((bookModel) => BookModel.toEntity(bookModel)).toList());
    } catch (e) {
      return left(
        e.toString(),
      );
    }
  }
}
