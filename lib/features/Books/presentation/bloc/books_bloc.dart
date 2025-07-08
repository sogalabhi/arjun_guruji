import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:arjun_guruji/features/Books/domain/usecases/books_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'books_events.dart';
part 'books_states.dart';
part 'books_bloc.freezed.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final FetchBooksUseCase fetchBooksUseCase;
  final FetchBookSummariesUseCase fetchBookSummariesUseCase;
  final FetchBookDetailsByTitleUseCase fetchBookDetailsByTitleUseCase;
  final Box<BookModel> booksBox;
  final Connectivity connectivity;

  BooksBloc({
    required this.fetchBooksUseCase,
    required this.fetchBookSummariesUseCase,
    required this.fetchBookDetailsByTitleUseCase,
    required this.booksBox,
    required this.connectivity,
  }) : super(const BooksState.initial()) {
    on<FetchAllBooks>(_onFetchBooks);
    on<FetchBookSummaries>(_onFetchBookSummaries);
    on<FetchBookDetailsByTitle>(_onFetchBookDetailsByTitle);
  }

  Future<void> _onFetchBooks(
      FetchAllBooks event, Emitter<BooksState> emit) async {
    emit(const BooksState.loading());

    try {
      final List<ConnectivityResult> connectivityResults =
          await connectivity.checkConnectivity();
      final ConnectivityResult connectivityResult =
          connectivityResults.isNotEmpty
              ? connectivityResults.first
              : ConnectivityResult.none;
      if (connectivityResult == ConnectivityResult.none) {
        try {
          // No internet - Fetch from local Hive database
          final List<BookModel> localBooks = booksBox.values.toList();
          final List<Book> books = localBooks
              .map((bookModel) => BookModel.toEntity(bookModel))
              .toList();

          emit(BooksState.booksLoaded(books));
        } catch (e) {
          emit(
              BooksState.error("Failed to load books from local database: $e"));
        }
        return;
      }

      // Internet is available - Fetch from Firestore
      final Either<String, List<Book>> result =
          await fetchBooksUseCase.call(NoParams());

      await result.fold(
        (failure) async =>
            emit(BooksState.error(failure)), // Handle failure properly
        (books) async {
          final List<BookModel> bookModels =
              books.map((book) => BookModel.fromEntity(book)).toList();

          // Store books in Hive (await to ensure completion)
          await booksBox.clear();
          await booksBox.addAll(bookModels);

          if (!emit.isDone) {
            emit(BooksState.booksLoaded(books));
          }
        },
      );
    } catch (e) {
      print(
          "Error in _onFetchBooks: $e"); // Print unexpected errors for debugging
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
