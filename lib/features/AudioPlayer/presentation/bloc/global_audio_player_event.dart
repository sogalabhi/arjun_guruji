import 'package:equatable/equatable.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';

abstract class GlobalAudioPlayerEvent extends Equatable {
  const GlobalAudioPlayerEvent();

  @override
  List<Object?> get props => [];
}

class PlayAudio extends GlobalAudioPlayerEvent {
  final CategoryEntity category;
  final int index;

  const PlayAudio({required this.category, required this.index});

  @override
  List<Object?> get props => [category, index];
}

class PauseAudio extends GlobalAudioPlayerEvent {}

class ResumeAudio extends GlobalAudioPlayerEvent {}

class StopAudio extends GlobalAudioPlayerEvent {}

class SeekAudio extends GlobalAudioPlayerEvent {
  final Duration position;

  const SeekAudio(this.position);

  @override
  List<Object?> get props => [position];
}

class PlayNextAudio extends GlobalAudioPlayerEvent {}

class PlayPreviousAudio extends GlobalAudioPlayerEvent {}

class ToggleLoopMode extends GlobalAudioPlayerEvent {}

class ToggleShuffleMode extends GlobalAudioPlayerEvent {}

class SetPlayerPageOpen extends GlobalAudioPlayerEvent {
  final bool isOpen;

  const SetPlayerPageOpen(this.isOpen);

  @override
  List<Object?> get props => [isOpen];
}
