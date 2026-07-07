import 'package:equatable/equatable.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';
import 'package:just_audio/just_audio.dart';

class GlobalAudioPlayerState extends Equatable {
  final bool isPlaying;
  final bool isLoading;
  final Duration currentPosition;
  final Duration totalDuration;
  final CategoryEntity? currentCategory;
  final int currentIndex;
  final LoopMode loopMode;
  final bool isShuffleEnabled;
  final bool isPlayerPageOpen;

  const GlobalAudioPlayerState({
    this.isPlaying = false,
    this.isLoading = false,
    this.currentPosition = Duration.zero,
    this.totalDuration = Duration.zero,
    this.currentCategory,
    this.currentIndex = 0,
    this.loopMode = LoopMode.off,
    this.isShuffleEnabled = false,
    this.isPlayerPageOpen = false,
  });

  AudioEntity? get currentAudio {
    if (currentCategory != null && currentIndex >= 0 && currentIndex < currentCategory!.audios.length) {
      return currentCategory!.audios[currentIndex];
    }
    return null;
  }

  GlobalAudioPlayerState copyWith({
    bool? isPlaying,
    bool? isLoading,
    Duration? currentPosition,
    Duration? totalDuration,
    CategoryEntity? currentCategory,
    int? currentIndex,
    LoopMode? loopMode,
    bool? isShuffleEnabled,
    bool? isPlayerPageOpen,
  }) {
    return GlobalAudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      isLoading: isLoading ?? this.isLoading,
      currentPosition: currentPosition ?? this.currentPosition,
      totalDuration: totalDuration ?? this.totalDuration,
      currentCategory: currentCategory ?? this.currentCategory,
      currentIndex: currentIndex ?? this.currentIndex,
      loopMode: loopMode ?? this.loopMode,
      isShuffleEnabled: isShuffleEnabled ?? this.isShuffleEnabled,
      isPlayerPageOpen: isPlayerPageOpen ?? this.isPlayerPageOpen,
    );
  }

  @override
  List<Object?> get props => [
        isPlaying,
        isLoading,
        currentPosition,
        totalDuration,
        currentCategory,
        currentIndex,
        loopMode,
        isShuffleEnabled,
        isPlayerPageOpen,
      ];
}
