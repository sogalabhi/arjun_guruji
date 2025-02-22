part of 'books_bloc.dart';

@freezed
class BooksState with _$BooksState {
  const factory BooksState.initial() = Initial;

  const factory BooksState.loading() = Loading;

  const factory BooksState.booksLoaded(List<Book> books) = BooksLoaded;

  const factory BooksState.error(String message) = Error;
}
