import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/audio.dart';

class AudioPlayerPage extends StatefulWidget {
  final AudioEntity audio;
  final CategoryEntity category;
  final int index;
  const AudioPlayerPage(
      {super.key,
      required this.audio,
      required this.category,
      required this.index});

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
      _audioPlayer.positionStream.listen((position) {
        setState(() {
          _sliderValue = position.inMilliseconds.toDouble();
        });
      });

      _audioPlayer.durationStream.listen((duration) {
        setState(() {
          _maxSliderValue = duration?.inMilliseconds.toDouble() ?? 0.0;
        });
      });

      _audioPlayer.playerStateStream.listen((playerState) {
        setState(() {
          _isPlaying = playerState.playing;
          if (_isPlaying) {
            _animationController.forward();
          } else {
            _animationController.reverse();
          }
        });
      });

      await _audioPlayer.play();
    } catch (e) {
      print("url: ${widget.category.audios[_currentIndex].audioUrl}");
      print("Error initializing audio player: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
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
    if (_currentIndex < widget.category.audios.length - 1) {
      setState(() {
        _currentIndex++;
      });
      await _initAudioPlayer();
      _playAudio();
    }
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.white;
    final iconColor = theme.iconTheme.color ?? Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.audios[_currentIndex].title),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Audio Image and Title or Lyrics or Playlist
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _isLyricsVisible
                      ? Column(
                          key: const ValueKey('lyrics'),
                          children: [
                            Text(
                              'Lyrics',
                              style: TextStyle(
                                color: textColor,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(
                                  widget.category.audios[_currentIndex].lyrics,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : _isPlaylistVisible
                          ? Column(
                              key: const ValueKey('playlist'),
                              children: [
                                Text(
                                  'Playlist',
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: widget.category.audios.length,
                                    itemBuilder: (context, index) {
                                      return ListTile(
                                        title: Text(
                                          widget.category.audios[index].title,
                                          style: TextStyle(
                                            color: index == _currentIndex
                                                ? theme.colorScheme.secondary
                                                : textColor,
                                          ),
                                        ),
                                        onTap: () async {
                                          setState(() {
                                            _currentIndex = index;
                                          });
                                          await _initAudioPlayer();
                                          _playAudio();
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            )
                          : Column(
                              key: const ValueKey('image'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.asset(
                                    widget.category.audios[_currentIndex]
                                        .imageUrl,
                                    width: 250,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  widget.category.audios[_currentIndex].title,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  widget
                                      .category.audios[_currentIndex].category,
                                  style: TextStyle(
                                    color: theme.textTheme.bodySmall?.color ??
                                        Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
              // Seekbar
              Slider(
                value: _sliderValue,
                min: 0,
                max: _maxSliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                  });
                  _seekAudio(value);
                },
                activeColor: theme.colorScheme.secondary,
                inactiveColor: theme.disabledColor,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatDuration(
                        Duration(milliseconds: _sliderValue.toInt())),
                    style: TextStyle(color: textColor),
                  ),
                  Text(
                    _formatDuration(
                        Duration(milliseconds: _maxSliderValue.toInt())),
                    style: TextStyle(color: textColor),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Lyrics and Playlist Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.lyrics,
                      color: _isLyricsVisible
                          ? theme.colorScheme.secondary
                          : theme.disabledColor,
                    ),
                    tooltip: 'Show Lyrics',
                    onPressed: () {
                      setState(() {
                        _isLyricsVisible = !_isLyricsVisible;
                        _isPlaylistVisible = false;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.playlist_play,
                      color: _isPlaylistVisible
                          ? theme.colorScheme.secondary
                          : theme.disabledColor,
                    ),
                    tooltip: 'Show Playlist',
                    onPressed: () {
                      setState(() {
                        _isPlaylistVisible = !_isPlaylistVisible;
                        _isLyricsVisible = false;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Player Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.shuffle, color: theme.disabledColor),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(Icons.skip_previous, color: iconColor),
                    onPressed: _playPrevious,
                  ),
                  _isLoading
                      ? CircularProgressIndicator(
                          color: theme.colorScheme.secondary,
                        )
                      : IconButton(
                          iconSize: 40,
                          icon: AnimatedIcon(
                            icon: AnimatedIcons.play_pause,
                            progress: _animationController,
                            color: iconColor,
                          ),
                          onPressed: () {
                            if (_isPlaying) {
                              _pauseAudio();
                            } else {
                              _playAudio();
                            }
                          },
                        ),
                  IconButton(
                    icon: Icon(Icons.skip_next, color: iconColor),
                    onPressed: _playNext,
                  ),
                  IconButton(
                    icon: Icon(Icons.repeat, color: theme.disabledColor),
                    onPressed: () {},
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
