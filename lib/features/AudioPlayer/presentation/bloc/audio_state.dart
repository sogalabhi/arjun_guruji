part of 'audio_bloc.dart';

@freezed
class AudioState with _$AudioState {
  const factory AudioState.initial() = Initial;

  const factory AudioState.loading() = Loading;

  const factory AudioState.audioLoaded(List<CategoryEntity> audios) = AudioLoaded;

  const factory AudioState.error(String message) = Error;
}
