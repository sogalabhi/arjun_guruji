import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:hive/hive.dart';
import 'global_audio_player_event.dart';
import 'global_audio_player_state.dart';

// Internal events for stream updates
class _PositionUpdated extends GlobalAudioPlayerEvent {
  final Duration position;
  const _PositionUpdated(this.position);
}

class _DurationUpdated extends GlobalAudioPlayerEvent {
  final Duration duration;
  const _DurationUpdated(this.duration);
}

class _PlayerStateUpdated extends GlobalAudioPlayerEvent {
  final PlayerState playerState;
  const _PlayerStateUpdated(this.playerState);
}

class GlobalAudioPlayerBloc
    extends Bloc<GlobalAudioPlayerEvent, GlobalAudioPlayerState> {
  final AudioPlayer _audioPlayer;
  final Box _settingsBox;

  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _playerStateSub;

  GlobalAudioPlayerBloc({required Box settingsBox})
      : _settingsBox = settingsBox,
        _audioPlayer = AudioPlayer(),
        super(const GlobalAudioPlayerState()) {
    on<PlayAudio>(_onPlayAudio);
    on<PauseAudio>(_onPauseAudio);
    on<ResumeAudio>(_onResumeAudio);
    on<StopAudio>(_onStopAudio);
    on<SeekAudio>(_onSeekAudio);
    on<PlayNextAudio>(_onPlayNextAudio);
    on<PlayPreviousAudio>(_onPlayPreviousAudio);
    on<ToggleLoopMode>(_onToggleLoopMode);
    on<ToggleShuffleMode>(_onToggleShuffleMode);
    on<SetPlayerPageOpen>((event, emit) => emit(state.copyWith(isPlayerPageOpen: event.isOpen)));

    on<_PositionUpdated>((event, emit) => emit(state.copyWith(currentPosition: event.position)));
    on<_DurationUpdated>((event, emit) => emit(state.copyWith(totalDuration: event.duration)));
    on<_PlayerStateUpdated>(_onPlayerStateUpdated);

    _loadSavedPreferences();
    _initStreams();
  }

  void _loadSavedPreferences() {
    final savedLoopMode = _settingsBox.get('audio_loop_mode', defaultValue: 0);
    final savedShuffle = _settingsBox.get('audio_shuffle_mode', defaultValue: false);
    
    final loopMode = LoopMode.values.firstWhere(
      (e) => e.index == savedLoopMode, 
      orElse: () => LoopMode.off,
    );
    
    _audioPlayer.setLoopMode(loopMode);
    _audioPlayer.setShuffleModeEnabled(savedShuffle);
    
    // We update the initial state through an internal synchronous method before first emit
    // but we can't emit from constructor directly. We'll add a dummy event or just let it sync later.
    // Actually, we can't emit in constructor without an event.
    // The state will sync up on the first real event.
  }

  void _initStreams() {
    _positionSub = _audioPlayer.positionStream.listen((position) {
      if (!isClosed) add(_PositionUpdated(position));
    });

    _durationSub = _audioPlayer.durationStream.listen((duration) {
      if (!isClosed && duration != null) add(_DurationUpdated(duration));
    });

    _playerStateSub = _audioPlayer.playerStateStream.listen((playerState) {
      if (!isClosed) add(_PlayerStateUpdated(playerState));
    });
  }

  void _onPlayerStateUpdated(_PlayerStateUpdated event, Emitter<GlobalAudioPlayerState> emit) {
    final playerState = event.playerState;
    emit(state.copyWith(isPlaying: playerState.playing));

    if (playerState.processingState == ProcessingState.completed) {
      if (state.loopMode == LoopMode.one) {
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
      } else if (state.loopMode == LoopMode.all) {
        add(PlayNextAudio());
      } else {
        add(StopAudio());
      }
    }
  }

  Future<void> _onPlayAudio(PlayAudio event, Emitter<GlobalAudioPlayerState> emit) async {
    // If the requested track is already loaded and we just want to play it
    if (state.currentCategory?.id == event.category.id && state.currentIndex == event.index) {
      await _audioPlayer.play();
      return;
    }

    emit(state.copyWith(
      isLoading: true,
      currentCategory: event.category,
      currentIndex: event.index,
    ));

    try {
      final audioInfo = event.category.audios[event.index];
      
      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(audioInfo.audioUrl),
          tag: MediaItem(
            id: audioInfo.id,
            title: audioInfo.title,
            artist: audioInfo.category,
            artUri: Uri.parse(audioInfo.imageUrl),
          ),
        ),
      );
      
      emit(state.copyWith(isLoading: false));
      await _audioPlayer.play();
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Handle error gracefully if needed
    }
  }

  Future<void> _onPauseAudio(PauseAudio event, Emitter<GlobalAudioPlayerState> emit) async {
    await _audioPlayer.pause();
  }

  Future<void> _onResumeAudio(ResumeAudio event, Emitter<GlobalAudioPlayerState> emit) async {
    await _audioPlayer.play();
  }

  Future<void> _onStopAudio(StopAudio event, Emitter<GlobalAudioPlayerState> emit) async {
    await _audioPlayer.stop();
    emit(state.copyWith(
      currentPosition: Duration.zero,
      isPlaying: false,
      // We don't nullify currentCategory so the UI can still show what was last playing,
      // or we can nullify it if we want the player snackbar to disappear.
      currentCategory: null,
    ));
  }

  Future<void> _onSeekAudio(SeekAudio event, Emitter<GlobalAudioPlayerState> emit) async {
    await _audioPlayer.seek(event.position);
  }

  Future<void> _onPlayNextAudio(PlayNextAudio event, Emitter<GlobalAudioPlayerState> emit) async {
    if (state.currentCategory == null) return;
    
    final audios = state.currentCategory!.audios;
    if (audios.isEmpty) return;

    int nextIndex;
    if (state.isShuffleEnabled) {
      final random = Random();
      do {
        nextIndex = random.nextInt(audios.length);
      } while (nextIndex == state.currentIndex && audios.length > 1);
    } else {
      nextIndex = (state.currentIndex + 1) % audios.length;
      if (nextIndex == 0 && state.loopMode == LoopMode.off) {
        add(StopAudio());
        return;
      }
    }
    
    add(PlayAudio(category: state.currentCategory!, index: nextIndex));
  }

  Future<void> _onPlayPreviousAudio(PlayPreviousAudio event, Emitter<GlobalAudioPlayerState> emit) async {
    if (state.currentCategory == null) return;
    
    final audios = state.currentCategory!.audios;
    if (audios.isEmpty) return;

    // If more than 3 seconds in, just restart current track
    if (state.currentPosition.inSeconds > 3) {
      await _audioPlayer.seek(Duration.zero);
      return;
    }

    int prevIndex;
    if (state.isShuffleEnabled) {
      prevIndex = Random().nextInt(audios.length);
    } else {
      prevIndex = state.currentIndex - 1;
      if (prevIndex < 0) {
        prevIndex = audios.length - 1;
      }
    }
    
    add(PlayAudio(category: state.currentCategory!, index: prevIndex));
  }

  void _onToggleLoopMode(ToggleLoopMode event, Emitter<GlobalAudioPlayerState> emit) {
    LoopMode nextMode;
    switch (state.loopMode) {
      case LoopMode.off:
        nextMode = LoopMode.all;
        break;
      case LoopMode.all:
        nextMode = LoopMode.one;
        break;
      case LoopMode.one:
        nextMode = LoopMode.off;
        break;
    }
    _audioPlayer.setLoopMode(nextMode);
    _settingsBox.put('audio_loop_mode', nextMode.index);
    emit(state.copyWith(loopMode: nextMode));
  }

  void _onToggleShuffleMode(ToggleShuffleMode event, Emitter<GlobalAudioPlayerState> emit) {
    final nextShuffle = !state.isShuffleEnabled;
    _audioPlayer.setShuffleModeEnabled(nextShuffle);
    _settingsBox.put('audio_shuffle_mode', nextShuffle);
    emit(state.copyWith(isShuffleEnabled: nextShuffle));
  }

  @override
  Future<void> close() {
    _positionSub?.cancel();
    _durationSub?.cancel();
    _playerStateSub?.cancel();
    _audioPlayer.dispose();
    return super.close();
  }
}
