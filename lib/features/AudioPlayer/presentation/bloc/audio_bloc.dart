import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/usecases/audio_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_event.dart';
part 'audio_state.dart';
part 'audio_bloc.freezed.dart';

class AudioBloc extends Bloc<AudioEvent, AudioState> {
  final FetchAudioUseCase fetchAudioUseCase;

  AudioBloc({
    required this.fetchAudioUseCase,
  }) : super(const AudioState.initial()) {
    on<FetchAllAudio>(_onFetchAudio);
  }

  Future<void> _onFetchAudio(
      FetchAllAudio event, Emitter<AudioState> emit) async {
    emit(const AudioState.loading());

    try {
      final Either<String, List<CategoryEntity>> result =
          await fetchAudioUseCase.call(NoParams());

      await result.fold(
        (failure) async => emit(AudioState.error(failure)),
        (audioList) async {
          if (!emit.isDone) {
            emit(AudioState.audioLoaded(audioList));
          }
        },
      );
    } catch (e) {
      if (!emit.isDone) {
        emit(AudioState.error("Failed to load audio list: $e"));
      }
    }
  }
}
