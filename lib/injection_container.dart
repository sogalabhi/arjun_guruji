import 'package:arjun_guruji/features/Books/data/datasource/books_remote_ds.dart';
import 'package:arjun_guruji/features/Books/data/repository/books_repository_impl.dart';
import 'package:arjun_guruji/features/Books/domain/repository/books_repository.dart';
import 'package:arjun_guruji/features/Books/domain/usecases/FetchBooksUseCase.dart';
import 'package:arjun_guruji/features/Books/presentation/bloc/books_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

final GetIt sl = GetIt.instance;

void setupLocator() {
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  books();
}

void books() {
  sl.registerLazySingleton<BookRepository>(
    () => BooksRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<BooksRemoteDataSource>(
      () => BooksRemoteDataSourceImpl(firestore: sl()));

  sl.registerFactory(() => FetchBooksUseCase(sl()));
  sl.registerFactory(() => BooksBloc(fetchBooksUseCase: sl()));
}
