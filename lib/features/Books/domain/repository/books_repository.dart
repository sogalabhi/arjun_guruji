import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:dartz/dartz.dart';

abstract class BookRepository {
  Future<Either<String, List<Book>>> fetchAllBooks();
}
