part of 'lyrics_bloc.dart';

@freezed
class LyricsState with _$LyricsState {
  const factory LyricsState.initial() = Initial;

  const factory LyricsState.loading() = Loading;

  const factory LyricsState.lyricsLoaded(List<Lyrics> lyrics) = LyricsLoaded;

  const factory LyricsState.error(String message) = Error;
}
