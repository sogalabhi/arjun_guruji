import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/Lyrics/domain/entity/lyrics.dart';
import 'package:arjun_guruji/features/Lyrics/domain/usecases/fetch_astottaras_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'lyrics_events.dart';
part 'lyrics_states.dart';
part 'lyrics_bloc.freezed.dart';

class LyricsBloc extends Bloc<LyricsEvent, LyricsState> {
  final FetchLyricsUseCase fetchLyricsUseCase;
  final Connectivity connectivity;

  LyricsBloc({
    required this.fetchLyricsUseCase,
    required this.connectivity,
  }) : super(const LyricsState.initial()) {
    on<FetchAllLyrics>(_onFetchLyrics);
  }

  Future<void> _onFetchLyrics(
      FetchAllLyrics event, Emitter<LyricsState> emit) async {
    emit(const LyricsState.loading());

    try {
      final Either<String, List<Lyrics>> result =
          await fetchLyricsUseCase.call(NoParams());

      await result.fold(
        (failure) async => emit(LyricsState.error(failure)),
        (lyrics) async {
          if (!emit.isDone) {
            emit(LyricsState.lyricsLoaded(lyrics));
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(LyricsState.error("Failed to load lyrics: $e"));
      }
    }
  }
}
