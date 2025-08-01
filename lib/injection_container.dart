import 'package:arjun_guruji/features/Admin/domain/usecases/upload_event_image_usecase.dart';
import 'package:arjun_guruji/features/Astottaras/data/datasource/ast_remote_ds.dart';
import 'package:arjun_guruji/features/Astottaras/data/model/astottara_model.dart';
import 'package:arjun_guruji/features/Astottaras/data/repository/astottara_repository_impl.dart';
import 'package:arjun_guruji/features/Astottaras/domain/repository/astottaras_repository.dart';
import 'package:arjun_guruji/features/Astottaras/domain/usecases/fetch_astottaras_usecase.dart';
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
import 'package:arjun_guruji/features/Lyrics/data/datasource/lyrics_remote_datastructure.dart';
import 'package:arjun_guruji/features/Lyrics/data/model/lyrics_model.dart';
import 'package:arjun_guruji/features/Lyrics/data/repository/lyrics_repository_impl.dart';
import 'package:arjun_guruji/features/Lyrics/domain/repository/lyrics_repository.dart';
import 'package:arjun_guruji/features/Lyrics/domain/usecases/fetch_astottaras_usecase.dart';
import 'package:arjun_guruji/features/Lyrics/presentation/bloc/lyrics_bloc.dart';
import 'package:arjun_guruji/features/Notifications/data/datasource/notifications_remote_ds.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'features/Admin/data/datasource/event_remote_datasource.dart';
import 'features/Admin/data/repository/event_repository_impl.dart';
import 'features/Admin/domain/repository/event_repository.dart';
import 'features/Admin/domain/usecases/create_event_usecase.dart';
import 'features/Admin/domain/usecases/get_events_usecase.dart';
import 'features/Admin/domain/usecases/update_event_usecase.dart';
import 'features/Admin/domain/usecases/delete_event_usecase.dart';
import 'features/Admin/presentation/bloc/event_bloc.dart';
import 'features/Admin/data/datasource/notification_remote_datasource.dart';
import 'features/Admin/data/repository/notification_repository_impl.dart';
import 'features/Admin/domain/repository/notification_repository.dart';
import 'features/Admin/domain/usecases/get_notifications_usecase.dart';
import 'features/Admin/domain/usecases/create_notification_usecase.dart';
import 'features/Admin/domain/usecases/update_notification_usecase.dart';
import 'features/Admin/domain/usecases/delete_notification_usecase.dart';
import 'features/Admin/domain/usecases/upload_notification_image_usecase.dart';
import 'features/Admin/presentation/bloc/notification_bloc.dart';

final GetIt sl = GetIt.instance;

void setupLocator() {
  // Register Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  //Firebase
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  sl.registerLazySingleton(() => FirebaseStorage.instance);

  books();
  astottaras();
  audio();
  lyrics();
  adminEvents();
  adminNotifications();

  // Register NotificationsRemoteDataSource
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSource(firestoreInstance: sl()),
  );
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
  sl.registerFactory(() => FetchBookSummariesUseCase(sl()));
  sl.registerFactory(() => FetchBookDetailsByTitleUseCase(sl()));

  // Register Hive Box instance
  final Box<BookModel> booksBox = await Hive.openBox<BookModel>('booksBox');
  sl.registerLazySingleton<Box<BookModel>>(() => booksBox);

  sl.registerFactory(() => BooksBloc(
        fetchBooksUseCase: sl(),
        fetchBookSummariesUseCase: sl(),
        fetchBookDetailsByTitleUseCase: sl(),
        booksBox: sl(),
        connectivity: sl(),
      ));
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

void lyrics() async {
  sl.registerLazySingleton<LyricsRepository>(
    () => LyricsRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  sl.registerLazySingleton<LyricsRemoteDataSource>(
      () => LyricsRemoteDataSourceImpl(firestore: sl()));

  sl.registerFactory(() => FetchLyricsUseCase(sl()));

  // Register Hive Box instance
  final Box<LyricsModel> lyricsBox =
      await Hive.openBox<LyricsModel>('lyricsBox');
  sl.registerLazySingleton<Box<LyricsModel>>(() => lyricsBox);

  sl.registerFactory(() => LyricsBloc(
      fetchLyricsUseCase: sl(), lyricsBox: sl(), connectivity: sl()));
}

void adminEvents() {
  sl.registerLazySingleton<EventRemoteDataSource>(
    () => EventRemoteDataSourceImpl(
        sl<FirebaseFirestore>(), sl<FirebaseStorage>()),
  );
  sl.registerLazySingleton<EventRepository>(
    () => EventRepositoryImpl(sl<EventRemoteDataSource>()),
  );
  sl.registerFactory(() => CreateEventUseCase(sl<EventRepository>()));
  sl.registerFactory(() => GetEventsUseCase(sl<EventRepository>()));
  sl.registerFactory(() => UpdateEventUseCase(sl<EventRepository>()));
  sl.registerFactory(() => DeleteEventUseCase(sl<EventRepository>()));
  sl.registerFactory(() => UploadEventImageUseCase(sl<EventRepository>()));
  sl.registerFactory(() => EventBloc(
        getEvents: sl<GetEventsUseCase>(),
        createEvent: sl<CreateEventUseCase>(),
        updateEvent: sl<UpdateEventUseCase>(),
        deleteEvent: sl<DeleteEventUseCase>(),
        uploadEventImage: sl<UploadEventImageUseCase>(),
      ));
}

void adminNotifications() {
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
        sl<FirebaseFirestore>(), sl<FirebaseStorage>()),
  );
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl<NotificationRemoteDataSource>()),
  );
  sl.registerFactory(
      () => GetNotificationsUseCase(sl<NotificationRepository>()));
  sl.registerFactory(
      () => CreateNotificationUseCase(sl<NotificationRepository>()));
  sl.registerFactory(
      () => UpdateNotificationUseCase(sl<NotificationRepository>()));
  sl.registerFactory(
      () => DeleteNotificationUseCase(sl<NotificationRepository>()));
  sl.registerFactory(
      () => UploadNotificationImageUseCase(sl<NotificationRepository>()));
  sl.registerFactory(() => NotificationBloc(
        getNotifications: sl<GetNotificationsUseCase>(),
        createNotification: sl<CreateNotificationUseCase>(),
        updateNotification: sl<UpdateNotificationUseCase>(),
        deleteNotification: sl<DeleteNotificationUseCase>(),
        uploadNotificationImage: sl<UploadNotificationImageUseCase>(),
      ));
}
