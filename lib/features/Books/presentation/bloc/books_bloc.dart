import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:arjun_guruji/features/Books/domain/usecases/books_usecase.dart';
import 'package:arjun_guruji/features/Books/domain/usecases/get_cached_books_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'books_events.dart';
part 'books_states.dart';
part 'books_bloc.freezed.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final FetchBooksUseCase fetchAllBooksUseCase;
  final FetchBookSummariesUseCase fetchBookSummariesUseCase;
  final FetchBookDetailsByTitleUseCase fetchBookDetailsByTitleUseCase;
  final GetCachedBooksUseCase getCachedBooksUseCase;
  final Connectivity connectivity;

  BooksBloc({
    required this.fetchAllBooksUseCase,
    required this.fetchBookSummariesUseCase,
    required this.fetchBookDetailsByTitleUseCase,
    required this.getCachedBooksUseCase,
    required this.connectivity,
  }) : super(const BooksState.initial()) {
    on<FetchAllBooks>(_onFetchBooks);
    on<FetchBookSummaries>(_onFetchBookSummaries);
    on<FetchBookDetailsByTitle>(_onFetchBookDetailsByTitle);
  }

  Future<void> _onFetchBooks(
      FetchAllBooks event, Emitter<BooksState> emit) async {
    List<Book> cachedBooks = [];
    try {
      cachedBooks = getCachedBooksUseCase();

      if (cachedBooks.isNotEmpty) {
        emit(BooksState.booksLoaded(cachedBooks));
      } else {
        emit(const BooksState.loading());
      }
    } catch (e) {
      emit(const BooksState.loading());
    }

    try {
      final Either<String, List<Book>> result =
          await fetchAllBooksUseCase.call(NoParams());

      await result.fold(
        (failure) async {
          if (cachedBooks.isEmpty) {
            emit(BooksState.error(failure));
          }
        },
        (freshBooks) async {
          bool hasChanged = false;
          if (freshBooks.length != cachedBooks.length) {
            hasChanged = true;
          } else {
            for (int i = 0; i < freshBooks.length; i++) {
              final remote = freshBooks[i];
              final local = cachedBooks[i];
              if (remote.title != local.title ||
                  remote.imageUrl != local.imageUrl ||
                  remote.bookType != local.bookType ||
                  remote.htmlContent != local.htmlContent ||
                  remote.pdfUrl != local.pdfUrl ||
                  remote.lastUpdated != local.lastUpdated) {
                hasChanged = true;
                break;
              }
            }
          }

          if (hasChanged && !emit.isDone) {
            emit(BooksState.booksLoaded(freshBooks));
          }
        },
      );
    } catch (e) {
      if (cachedBooks.isEmpty) {
        emit(BooksState.error("Failed to load books: $e"));
      }
    }
  }

  Future<void> _onFetchBookSummaries(
      FetchBookSummaries event, Emitter<BooksState> emit) async {
    emit(const BooksState.loading());
    try {
      final result = await fetchBookSummariesUseCase.call(NoParams());
      await result.fold(
        (failure) async => emit(BooksState.error(failure)),
        (books) async => emit(BooksState.booksLoaded(books)),
      );
    } catch (e) {
      emit(BooksState.error(e.toString()));
    }
  }

  Future<void> _onFetchBookDetailsByTitle(
      FetchBookDetailsByTitle event, Emitter<BooksState> emit) async {
    emit(const BooksState.loading());
    try {
      final result = await fetchBookDetailsByTitleUseCase.call(event.title);
      await result.fold(
        (failure) async => emit(BooksState.error(failure)),
        (book) async => emit(BooksState.booksLoaded([book])),
      );
    } catch (e) {
      emit(BooksState.error(e.toString()));
    }
  }
}
