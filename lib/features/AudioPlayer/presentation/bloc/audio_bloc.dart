import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/usecases/audio_usecase.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_event.dart';
part 'audio_state.dart';
part 'audio_bloc.freezed.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final FetchAudioUseCase fetchAudioUseCase;
  final Connectivity connectivity;

  AudioBloc({
    required this.fetchAudioUseCase,
    required this.connectivity,
  }) : super(const AudioState.initial()) {
    on<FetchAllAudio>(_onFetchAudio);
  }

  Future<void> _onFetchAudio(
      FetchAllAudio event, Emitter<AudioState> emit) async {
    emit(const AudioState.loading());

    try {
      final List<ConnectivityResult> connectivityResults =
          await connectivity.checkConnectivity();
      final ConnectivityResult connectivityResult =
          connectivityResults.isNotEmpty
              ? connectivityResults.first
              : ConnectivityResult.none;
      if (connectivityResult == ConnectivityResult.none) {
        emit(const AudioState.error("No internet connection"));
        return;
      }

      // Internet is available - Fetch from the source
      final Either<String, List<CategoryEntity>> result =
          await fetchAudioUseCase.call(NoParams());

      await result.fold(
        (failure) async =>
            emit(AudioState.error(failure)), // Handle failure properly
        (audioList) async {
          if (!emit.isDone) {
            emit(AudioState.audioLoaded(audioList));
          }
        },
      );
    } catch (e) {
      print(
          "Error in _onFetchAudio: $e"); // Print unexpected errors for debugging
    }
  }
}
