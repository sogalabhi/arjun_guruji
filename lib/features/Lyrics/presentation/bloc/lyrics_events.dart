part of 'lyrics_bloc.dart';

@freezed
class LyricsEvent with _$LyricsEvent {
  const factory LyricsEvent.fetchAllLyrics() = FetchAllLyrics;
}
