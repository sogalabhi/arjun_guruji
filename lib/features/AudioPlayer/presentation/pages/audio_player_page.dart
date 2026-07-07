import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/bloc/global_audio_player_bloc.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/bloc/global_audio_player_event.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/bloc/global_audio_player_state.dart';
import 'package:arjun_guruji/injection_container.dart' as import_container;

class AudioPlayerPage extends StatefulWidget {
  final AudioEntity? audio; // Can be null if opening from snackbar
  final CategoryEntity category;
  final int index;

  const AudioPlayerPage({
    super.key,
    this.audio,
    required this.category,
    required this.index,
  });

  @override
  AudioPlayerPageState createState() => AudioPlayerPageState();
}

class AudioPlayerPageState extends State<AudioPlayerPage>
    with SingleTickerProviderStateMixin {
  bool _isLyricsVisible = false;
  bool _isPlaylistVisible = false;
  late AnimationController _animationController;
  bool _hasStartedInitialPlay = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    // Notify the global bloc that the player page is now visible (hides the snackbar)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<GlobalAudioPlayerBloc>().add(const SetPlayerPageOpen(true));
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    
    // Notify the global bloc that the player page is closed (shows the snackbar)
    // We can't safely access context.read in dispose sometimes, but usually it works if it's above us.
    // However, it's safer to use the injection container if we have issues.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Use the global context or the injected bloc to avoid context errors on pop
      import_container.sl<GlobalAudioPlayerBloc>().add(const SetPlayerPageOpen(false));
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GlobalAudioPlayerBloc, GlobalAudioPlayerState>(
      listener: (context, state) {
        if (state.isPlaying) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
      builder: (context, state) {
        // Trigger initial play if we are coming from a category list and not just reopening the player
        // We only trigger this once per page load if the currently playing category/index doesn't match
        if (!_hasStartedInitialPlay &&
            (state.currentCategory?.id != widget.category.id ||
                state.currentIndex != widget.index)) {
          _hasStartedInitialPlay = true;
          // Defer the event to avoid state updates during build
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<GlobalAudioPlayerBloc>().add(
                  PlayAudio(category: widget.category, index: widget.index),
                );
          });
        }

        final audio = state.currentAudio ?? (widget.audio ?? widget.category.audios[widget.index]);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;

            final bloc = context.read<GlobalAudioPlayerBloc>();
            if (bloc.state.isPlaying || bloc.state.currentPosition > Duration.zero) {
              final action = await _showExitDialog(context);
              if (action == 'stop') {
                bloc.add(StopAudio());
                if (context.mounted) Navigator.of(context).pop();
              } else if (action == 'keep') {
                if (context.mounted) Navigator.of(context).pop();
              }
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            appBar: const GradientAppBar(
              title: 'Audio Player',
            ),
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Blurred Background Image
                Positioned.fill(
                  child: CachedNetworkImage(
                    imageUrl: audio.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => const Center(child: Icon(Icons.error)),
                  ),
                ),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(color: Colors.black.withAlpha((0.5 * 255).toInt())),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AnimatedSwitcher for Image, Lyrics, or Playlist
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: _isLyricsVisible
                            ? _buildLyrics(audio)
                            : _isPlaylistVisible
                                ? _buildPlaylist(state)
                                : _buildImageAndTitle(audio),
                      ),
                    ),
                    // Progress Bar
                    Slider(
                      activeColor: Colors.white,
                      inactiveColor: Colors.grey,
                      min: 0,
                      max: state.totalDuration.inMilliseconds > 0
                          ? state.totalDuration.inMilliseconds.toDouble()
                          : 1.0,
                      value: state.currentPosition.inMilliseconds.toDouble().clamp(
                            0,
                            state.totalDuration.inMilliseconds > 0
                                ? state.totalDuration.inMilliseconds.toDouble()
                                : 1.0,
                          ),
                      onChanged: (value) {
                        context
                            .read<GlobalAudioPlayerBloc>()
                            .add(SeekAudio(Duration(milliseconds: value.toInt())));
                      },
                    ),
                    // Current Time and Total Time
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(state.currentPosition),
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            _formatDuration(state.totalDuration),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Player Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Shuffle Button
                        IconButton(
                          icon: Icon(
                            Icons.shuffle,
                            color: state.isShuffleEnabled ? Colors.blue : Colors.white,
                          ),
                          onPressed: () => context
                              .read<GlobalAudioPlayerBloc>()
                              .add(ToggleShuffleMode()),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
                          onPressed: () => context
                              .read<GlobalAudioPlayerBloc>()
                              .add(PlayPreviousAudio()),
                        ),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: state.isLoading
                              ? const CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                              : IconButton(
                                  key: ValueKey<bool>(state.isPlaying),
                                  icon: Icon(
                                    state.isPlaying
                                        ? Icons.pause_circle_filled
                                        : Icons.play_circle_fill,
                                    color: Colors.white,
                                    size: 60,
                                  ),
                                  onPressed: () {
                                    if (state.isPlaying) {
                                      context.read<GlobalAudioPlayerBloc>().add(PauseAudio());
                                    } else {
                                      context.read<GlobalAudioPlayerBloc>().add(ResumeAudio());
                                    }
                                  },
                                ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
                          onPressed: () => context
                              .read<GlobalAudioPlayerBloc>()
                              .add(PlayNextAudio()),
                        ),
                        // Loop Button
                        IconButton(
                          icon: Icon(
                            state.loopMode == LoopMode.one
                                ? Icons.repeat_one
                                : Icons.repeat,
                            color: state.loopMode != LoopMode.off ? Colors.blue : Colors.white,
                          ),
                          onPressed: () => context
                              .read<GlobalAudioPlayerBloc>()
                              .add(ToggleLoopMode()),
                        ),
                      ],
                    ),
                    // Toggle Lyrics & Playlist Buttons
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.lyrics,
                              size: 50,
                              color: _isLyricsVisible ? Colors.blue : Colors.white,
                            ),
                            onPressed: () => setState(() {
                              _isLyricsVisible = !_isLyricsVisible;
                              _isPlaylistVisible = false;
                            }),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.queue_music,
                              size: 50,
                              color: _isPlaylistVisible ? Colors.blue : Colors.white,
                            ),
                            onPressed: () => setState(() {
                              _isPlaylistVisible = !_isPlaylistVisible;
                              _isLyricsVisible = false;
                            }),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<String?> _showExitDialog(BuildContext context) async {
    return showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Audio is Playing'),
        content: const Text('Bhajan is still playing. What would you like to do?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop('stop'),
            child: const Text('Stop & Leave', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop('keep'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Keep Playing', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // Widget for Image and Title
  Widget _buildImageAndTitle(AudioEntity audio) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Hero(
          tag: 'category-image-${widget.category.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: audio.imageUrl,
              height: 250,
              width: 250,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          audio.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          audio.category,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  // Widget for Lyrics
  Widget _buildLyrics(AudioEntity audio) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Text(
        audio.lyrics.isNotEmpty ? audio.lyrics : "No lyrics available",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
    );
  }

  // Widget for Playlist
  Widget _buildPlaylist(GlobalAudioPlayerState state) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: widget.category.audios.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          widget.category.audios[index].title,
          style: TextStyle(
            color: index == state.currentIndex ? Colors.blue : Colors.white,
          ),
        ),
        onTap: () {
          context.read<GlobalAudioPlayerBloc>().add(
                PlayAudio(category: widget.category, index: index),
              );
        },
      ),
    );
  }

  // Format Duration to mm:ss
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
