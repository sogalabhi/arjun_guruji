part of 'books_bloc.dart';

@freezed
class BooksEvent with _$BooksEvent {
  const factory BooksEvent.fetchAllBooks() = FetchAllBooks;
  const factory BooksEvent.fetchBookSummaries() = FetchBookSummaries;
  const factory BooksEvent.fetchBookDetailsByTitle(String title) = FetchBookDetailsByTitle;
}
