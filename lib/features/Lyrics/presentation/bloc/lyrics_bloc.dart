import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/Lyrics/data/model/lyrics_model.dart';
import 'package:arjun_guruji/features/Lyrics/domain/entity/lyrics.dart';
import 'package:arjun_guruji/features/Lyrics/domain/usecases/fetch_astottaras_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'lyrics_events.dart';
part 'lyrics_states.dart';
part 'lyrics_bloc.freezed.dart';

class LyricsBloc extends Bloc<LyricsEvent, LyricsState> {
  final FetchLyricsUseCase fetchLyricsUseCase;
  final Box<LyricsModel> lyricsBox;
  final Connectivity connectivity;

  LyricsBloc({
    required this.fetchLyricsUseCase,
    required this.lyricsBox,
    required this.connectivity,
  }) : super(const LyricsState.initial()) {
    on<FetchAllLyrics>(_onFetchLyrics);
  }

  Future<void> _onFetchLyrics(
      FetchAllLyrics event, Emitter<LyricsState> emit) async {
    emit(const LyricsState.loading());

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
          final List<LyricsModel> localLyrics = lyricsBox.values.toList();
          final List<Lyrics> lyrics = localLyrics
              .map((lyricsModel) => LyricsModel.toEntity(lyricsModel))
              .toList();

          emit(LyricsState.lyricsLoaded(lyrics));
        } catch (e) {
          emit(LyricsState.error(
              "Failed to load lyrics from local database: $e"));
        }
        return;
      }

      // Internet is available - Fetch from Firestore
      final Either<String, List<Lyrics>> result =
          await fetchLyricsUseCase.call(NoParams());

      await result.fold(
        (failure) async =>
            emit(LyricsState.error(failure)), // Handle failure properly
        (lyrics) async {
          final List<LyricsModel> lyricsModels =
              lyrics.map((lyrics) => LyricsModel.fromEntity(lyrics)).toList();

          // Store lyrics in Hive (await to ensure completion)
          await lyricsBox.clear();
          await lyricsBox.addAll(lyricsModels);

          if (!emit.isDone) {
            emit(LyricsState.lyricsLoaded(lyrics));
          }
        },
      );
    } catch (e) {
      print(
          "Error in _onFetchLyrics: $e"); // Print unexpected errors for debugging
    }
  }
}
