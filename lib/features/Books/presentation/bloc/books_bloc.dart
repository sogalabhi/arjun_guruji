import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:arjun_guruji/features/Books/domain/usecases/FetchBooksUseCase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'books_events.dart';
part 'books_states.dart';
part 'books_bloc.freezed.dart';

class BooksBloc extends Bloc<BooksEvent, BooksState> {
  final FetchBooksUseCase fetchBooksUseCase;

  BooksBloc({required this.fetchBooksUseCase})
      : super(const BooksState.initial()) {
    on<FetchAllBooks>(_onFetchBooks);
  }

  Future<void> _onFetchBooks(FetchAllBooks event, Emitter<BooksState> emit) async {
    emit(const BooksState.loading());
    final Either<String, List<Book>> result =
        await fetchBooksUseCase.call(NoParams());
    result.fold(
      (failure) => emit(BooksState.error(failure)),
      (books) => emit(BooksState.booksLoaded(books)),
    );
  }
}
