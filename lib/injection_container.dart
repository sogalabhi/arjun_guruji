import 'package:arjun_guruji/features/Astottaras/data/datasource/ast_remote_ds.dart';
import 'package:arjun_guruji/features/Astottaras/data/model/astottara_model.dart';
import 'package:arjun_guruji/features/Astottaras/data/repository/astottara_repository_impl.dart';
import 'package:arjun_guruji/features/Astottaras/domain/repository/astottaras_repository.dart';
import 'package:arjun_guruji/features/Astottaras/domain/usecases/FetchAstottarasUseCase.dart';
import 'package:arjun_guruji/features/Astottaras/presentation/bloc/astottara_bloc.dart';
import 'package:arjun_guruji/features/AudioPlayer/data/datasource/audio_remote_datasource.dart';
import 'package:arjun_guruji/features/AudioPlayer/data/repository/audio_repository_impl.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/repository/audio_repository.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/usecases/audio_usecase.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/bloc/audio_bloc.dart';
import 'package:arjun_guruji/features/Books/data/datasource/books_remote_ds.dart';
import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:arjun_guruji/features/Books/data/repository/books_repository_impl.dart';
import 'package:arjun_guruji/features/Books/domain/repository/books_repository.dart';
import 'package:arjun_guruji/features/Books/domain/usecases/books_usecase.dart';
import 'package:arjun_guruji/features/Books/presentation/bloc/books_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

final GetIt sl = GetIt.instance;

void setupLocator() {
  // Register Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  //Firebase
  sl.registerLazySingleton(() => FirebaseFirestore.instance);

  books();
  astottaras();
  audio();
}

void books() async {
  sl.registerLazySingleton<BookRepository>(
    () => BooksRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<BooksRemoteDataSource>(
      () => BooksRemoteDataSourceImpl(firestore: sl()));

  sl.registerFactory(() => FetchBooksUseCase(sl()));

  // Register Hive Box instance
  final Box<BookModel> booksBox = await Hive.openBox<BookModel>('booksBox');
  sl.registerLazySingleton<Box<BookModel>>(() => booksBox);

  sl.registerFactory(() =>
      BooksBloc(fetchBooksUseCase: sl(), booksBox: sl(), connectivity: sl()));
}

void astottaras() async {
  sl.registerLazySingleton<AstottaraRepository>(
    () => AstottarasRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<AstottarasRemoteDataSource>(
      () => AstottarasRemoteDataSourceImpl(firestore: sl()));

  sl.registerFactory(() => FetchAstottarasUseCase(sl()));

  // Register Hive Box instance
  final Box<AstottaraModel> astottaraBox =
      await Hive.openBox<AstottaraModel>('astottarasBox');
  sl.registerLazySingleton<Box<AstottaraModel>>(() => astottaraBox);

  sl.registerFactory(() => AstottarasBloc(
      fetchAstottarasUseCase: sl(), astottarasBox: sl(), connectivity: sl()));
}

void audio() async {
  sl.registerLazySingleton<AudioRepository>(
    () => AudioRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<AudioRemoteDataSource>(
      () => AudioRemoteDataSourceImpl(firestore: sl()));

  sl.registerFactory(() => FetchAudioUseCase(sl()));

  sl.registerFactory(
      () => AudioBloc(fetchAudioUseCase: sl(), connectivity: sl()));
}
