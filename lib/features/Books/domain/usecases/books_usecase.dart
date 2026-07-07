import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:arjun_guruji/features/Books/domain/repository/books_repository.dart';
import 'package:dartz/dartz.dart';

class FetchBooksUseCase implements Usecase<List<Book>, NoParams, String> {
  final BookRepository bookRepository;

  FetchBooksUseCase(this.bookRepository);

  @override
  Future<Either<String, List<Book>>> call(NoParams params) async {
    return await bookRepository.fetchAllBooks();
  }
}

class FetchBookSummariesUseCase
    implements Usecase<List<Book>, NoParams, String> {
  final BookRepository bookRepository;
  FetchBookSummariesUseCase(this.bookRepository);
  @override
  Future<Either<String, List<Book>>> call(NoParams params) async {
    return await bookRepository.fetchBookSummaries();
  }
}

class FetchBookDetailsByTitleUseCase implements Usecase<Book, String, String> {
  final BookRepository bookRepository;
  FetchBookDetailsByTitleUseCase(this.bookRepository);
  @override
  Future<Either<String, Book>> call(String title) async {
    return await bookRepository.fetchBookDetailsByTitle(title);
  }
}
