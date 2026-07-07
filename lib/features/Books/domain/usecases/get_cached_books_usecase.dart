import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:arjun_guruji/features/Books/domain/repository/books_repository.dart';

class GetCachedBooksUseCase {
  final BookRepository repository;
  GetCachedBooksUseCase(this.repository);

  List<Book> call() {
    return repository.getCachedBooks();
  }
}
