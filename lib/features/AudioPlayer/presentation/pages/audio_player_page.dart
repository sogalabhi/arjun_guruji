import 'dart:math';
import 'dart:ui';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AudioPlayerPage extends StatefulWidget {
  final AudioEntity audio;
  final CategoryEntity category;
  final int index;

  const AudioPlayerPage({
    Key? key,
    required this.audio,
    required this.category,
    required this.index,
  }) : super(key: key);

  @override
  AudioPlayerPageState createState() => AudioPlayerPageState();
}

class AudioPlayerPageState extends State<AudioPlayerPage>
    with SingleTickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLyricsVisible = false;
  bool _isPlaylistVisible = false;
  double _sliderValue = 0.0;
  double _maxSliderValue = 0.0;
  int _currentIndex = 0;
  late AnimationController _animationController;
  bool _isLoading = true;

  // Loop and Shuffle States
  LoopMode _loopMode = LoopMode.off;
  bool _isShuffleEnabled = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _currentIndex = widget.index;
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _initAudioPlayer();
  }

  Future<void> _initAudioPlayer() async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _audioPlayer.setAudioSource(
        AudioSource.uri(
          Uri.parse(widget.category.audios[_currentIndex].audioUrl),
          tag: MediaItem(
            id: widget.category.audios[_currentIndex].id,
            title: widget.category.audios[_currentIndex].title,
            artist: widget.category.audios[_currentIndex].category,
          ),
        ),
      );

      setState(() {
        _isLoading = false;
      });

      // Listen to position updates
      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _sliderValue = position.inMilliseconds.toDouble();
          // Clamp the slider value to the maximum duration
          if (_maxSliderValue > 0) {
            _sliderValue = _sliderValue.clamp(0, _maxSliderValue);
          }
        });
      });

      // Listen to duration updates
      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _maxSliderValue = duration?.inMilliseconds.toDouble() ?? 0.0;
        });
      });

      // Listen to playback state updates
      _audioPlayer.playerStateStream.listen((playerState) {
        setState(() {
          _isPlaying = playerState.playing;
          if (_isPlaying) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        });

        // Handle audio completion
        if (playerState.processingState == ProcessingState.completed) {
          _handleAudioCompletion();
        }
      });

      await _audioPlayer.play();
    } catch (e) {
      print("Error initializing audio player: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _handleAudioCompletion() {
    if (_loopMode == LoopMode.one) {
      // Loop the current song
      _audioPlayer.seek(Duration.zero);
      _audioPlayer.play();
    } else if (_loopMode == LoopMode.all) {
      // Play the next song
      _playNext();
    } else {
      // Stop playback
      _pauseAudio();
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    await _audioPlayer.play();
  }

  Future<void> _pauseAudio() async {
    await _audioPlayer.pause();
  }

  Future<void> _seekAudio(double value) async {
    await _audioPlayer.seek(Duration(milliseconds: value.toInt()));
  }

  Future<void> _playNext() async {
    if (_isShuffleEnabled) {
      // Play a random song
      final random = Random();
      int nextIndex;
      do {
        nextIndex = random.nextInt(widget.category.audios.length);
      } while (nextIndex == _currentIndex);
      _currentIndex = nextIndex;
    } else {
      // Play the next song in order
      if (_currentIndex < widget.category.audios.length - 1) {
        _currentIndex++;
      } else {
        _currentIndex = 0; // Loop back to the first song
      }
    }
    await _initAudioPlayer();
    _playAudio();
  }

  Future<void> _playPrevious() async {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
      });
      await _initAudioPlayer();
      _playAudio();
    }
  }

  void _toggleLoopMode() {
    setState(() {
      _loopMode = LoopMode.values[(_loopMode.index + 1) % LoopMode.values.length];
    });
  }

  void _toggleShuffle() {
    setState(() {
      _isShuffleEnabled = !_isShuffleEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final audio = widget.category.audios[_currentIndex];
    return Scaffold(
      appBar: AppBar(
        title: Text(audio.title),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Blurred Background Image
          Positioned.fill(
            child: CachedNetworkImage(
              imageUrl: audio.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(color: Colors.black.withOpacity(0.5)),
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
                          ? _buildPlaylist()
                          : _buildImageAndTitle(audio),
                ),
              ),
              // Progress Bar
              Slider(
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                min: 0,
                max: _maxSliderValue,
                value: _sliderValue,
                onChanged: (value) => _seekAudio(value),
              ),
              // Current Time and Total Time
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(Duration(milliseconds: _sliderValue.toInt())),
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      _formatDuration(Duration(milliseconds: _maxSliderValue.toInt())),
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
                      color: _isShuffleEnabled ? Colors.blue : Colors.white,
                    ),
                    onPressed: _toggleShuffle,
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_previous, color: Colors.white, size: 40),
                    onPressed: _playPrevious,
                  ),
                  IconButton(
                    icon: const Icon(Icons.replay_10, color: Colors.white, size: 40),
                    onPressed: () => _seekAudio(_sliderValue - 10000),
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          )
                        : IconButton(
                            key: ValueKey<bool>(_isPlaying),
                            icon: Icon(
                              _isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill,
                              color: Colors.white,
                              size: 60,
                            ),
                            onPressed: () {
                              if (_isPlaying) {
                                _pauseAudio();
                              } else {
                                _playAudio();
                              }
                            },
                          ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.forward_10, color: Colors.white, size: 40),
                    onPressed: () => _seekAudio(_sliderValue + 10000),
                  ),
                  IconButton(
                    icon: const Icon(Icons.skip_next, color: Colors.white, size: 40),
                    onPressed: _playNext,
                  ),
                  // Loop Button
                  IconButton(
                    icon: Icon(
                      _loopMode == LoopMode.one
                          ? Icons.repeat_one
                          : Icons.repeat,
                      color: _loopMode != LoopMode.off ? Colors.blue : Colors.white,
                    ),
                    onPressed: _toggleLoopMode,
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
  Widget _buildPlaylist() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: widget.category.audios.length,
      itemBuilder: (context, index) => ListTile(
        title: Text(
          widget.category.audios[index].title,
          style: TextStyle(
            color: index == _currentIndex ? Colors.blue : Colors.white,
          ),
        ),
        onTap: () async {
          setState(() {
            _currentIndex = index;
          });
          await _initAudioPlayer();
          _playAudio();
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