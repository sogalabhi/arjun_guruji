import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:rxdart/rxdart.dart';

class PositionData {
  PositionData(this.position, this.bufferedPosition, this.duration);
  final Duration position, bufferedPosition, duration;
}

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> {
  Map heading = {};
  late AudioPlayer _audioPlayer;
  late ConcatenatingAudioSource _playlist;

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _audioPlayer.positionStream,
        _audioPlayer.bufferedPositionStream,
        _audioPlayer.durationStream,
        (position, bufferedPosition, duration) => PositionData(
          position,
          bufferedPosition,
          duration ?? Duration.zero,
        ),
      );

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _init();
  }

  Future<void> _init() async {
    await _audioPlayer.setLoopMode(LoopMode.all);
    await _audioPlayer.setAudioSource(_playlist,
        initialIndex: heading['index']);
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    heading = ModalRoute.of(context)!.settings.arguments as Map;
    if (heading['desc'] == "Arati") {
      _playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2Fdayamaya%20guru.mp3?alt=media&token=fee0470d-19a1-406b-bbe1-d8f33e9e79fe'),
          tag: MediaItem(
            id: "0",
            title: 'ದಯಾಮಯ',
            artist: "ಆರತಿ",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2FHara%20Ganga%20Jatadhara%20Gouri%20Shankara%20(%20256kbps%20cbr%20).mp3?alt=media&token=7da0d3ca-9825-426b-b9ac-7ec896b9f811'),
          tag: MediaItem(
            id: "1",
            title: 'ಗಂಗಜಟಾಧರ',
            artist: "ಆರತಿ",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2Fsai%20baba%20dhoop%20aarti%20(Evening%20Aarti)%20(%20128kbps%20).mp3?alt=media&token=0bee713b-e653-4d2a-89dd-6ba73f8d8ab0'),
          tag: MediaItem(
            id: "3",
            title: 'ಸಂಜೆ ಆರತಿ',
            artist: "ಆರತಿ",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Arati%2FMangalam%20Guru%20Sri%20Chandramouleeshwara%20ke....Arathi%20song%20of%20Shri%20Sringeri%20Jagatguru%20%20parampariya..%20(%20256kbps%20cbr%20).mp3?alt=media&token=ff8c39ab-ef92-4bef-9a68-434ecdf906fa'),
          tag: MediaItem(
            id: "4",
            title: 'ಮಂಗಳಂ ಗುರು ಶ್ರೀ',
            artist: "ಆರತಿ",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55'),
          ),
        ),
      ]);
    } else if (heading['desc'] == "BhajaGurunatham") {
      _playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F1.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b'),
          tag: MediaItem(
            id: "0",
            title: 'ಸಖಾರಾಯಪಟ್ಟಣದ ನಾಥನೇ',
            artist: "ಭಜ ಗುರುನಾಥಮ್",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F2.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b'),
          tag: MediaItem(
            id: "1",
            title: 'ಗುರುನಾಮವೇ ಪಾವನಂ',
            artist: "ಭಜ ಗುರುನಾಥಮ್",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F3.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b'),
          tag: MediaItem(
            id: "0",
            title: 'ಭಜ ಗುರುನಾಥಮ್',
            artist: "ಭಜ ಗುರುನಾಥಮ್",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F4.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b'),
          tag: MediaItem(
            id: "1",
            title: 'ಗುರುನಾಥನೇ ನನ್ನ ಈಶ್ವರ',
            artist: "ಭಜ ಗುರುನಾಥಮ್",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F5.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b'),
          tag: MediaItem(
            id: "0",
            title: 'ಅರ್ಜುನಂ ಶ್ರೀಧರಂ',
            artist: "ಭಜ ಗುರುನಾಥಮ್",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F6.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b'),
          tag: MediaItem(
            id: "1",
            title: 'ನಾವು ನೀವು ಸೇರಿ',
            artist: "ಭಜ ಗುರುನಾಥಮ್",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhaja%20Gurunatham%2F7.mp3?alt=media&token=6c51c303-f754-4a4f-a125-206d3707e49b'),
          tag: MediaItem(
            id: "1",
            title: 'ನಮ್ಮ ಸದ್ಗುರು ಗುರುನಾಥ',
            artist: "ಭಜ ಗುರುನಾಥಮ್",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fbhajagurunnatham.jpeg?alt=media&token=80aed29b-05fb-4648-95a9-1b4a1c0ada1d'),
          ),
        ),
      ]);
    } else if (heading['desc'] == "Astottara") {
      _playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Astottara%2F1.mp3?alt=media&token=e7d4dbaa-2ff7-457a-8a2a-a8c3767136a9'),
          tag: MediaItem(
            id: "0",
            title: 'ಗುರುನಾಥರ ಅಷ್ಟೋತ್ತರ',
            artist: "ಅಷ್ಟೋತ್ತರ",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg12.jpg?alt=media&token=07712159-52e0-48d8-ac73-eac6557f340a'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Astottara%2F2.mp3?alt=media&token=9d51aab1-e020-4fe2-ae2d-e86a34ec846e'),
          tag: MediaItem(
            id: "1",
            title: 'ಅರ್ಜುನ ಗುರುಗಳ ಅಷ್ಟೋತ್ತರ',
            artist: "ಅಷ್ಟೋತ್ತರ",
            artUri: Uri.parse(
                'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg12.jpg?alt=media&token=07712159-52e0-48d8-ac73-eac6557f340a'),
          ),
        )
      ]);
    } else if (heading['desc'] == "BhuvanadaBhagya") {
      _playlist = ConcatenatingAudioSource(children: [
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F1.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2'),
          tag: MediaItem(
            id: "0",
            title: 'ಆರತಿ ಬೆಳಗಿರೋ',
            artist: 'ಭುವನದ ಭಾಗ್ಯ',
            artUri: Uri.parse('https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F2.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2'),
          tag: MediaItem(
            id: "0",
            title: 'ಬಾಬಾ ಬಂದರು ನಮ್ಮ ಮನೆಗೆ',
            artist: 'ಭುವನದ ಭಾಗ್ಯ',
            artUri: Uri.parse('https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F3.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2'),
          tag: MediaItem(
            id: "0",
            title: 'ಭುವನದ ಭಾಗ್ಯ',
            artist: 'ಭುವನದ ಭಾಗ್ಯ',
            artUri: Uri.parse('https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F4.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2'),
          tag: MediaItem(
            id: "0",
            title: 'ದಿವದಿಂದು ಭೂಮಿಗಿಳಿದು ಬಂದ',
            artist: 'ಭುವನದ ಭಾಗ್ಯ',
            artUri: Uri.parse('https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F5.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2'),
          tag: MediaItem(
            id: "0",
            title: 'ಏನು ಪದವೋ',
            artist: 'ಭುವನದ ಭಾಗ್ಯ',
            artUri: Uri.parse('https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F6.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2'),
          tag: MediaItem(
            id: "0",
            title: 'ಪಾಹಿ ಪಾಹಿ',
            artist: 'ಭುವನದ ಭಾಗ್ಯ',
            artUri: Uri.parse('https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F7.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2'),
          tag: MediaItem(
            id: "0",
            title: 'ಸಾಯಿ ಬಾಬಾ ಸಾಯಿ ಬಾಬಾ',
            artist: 'ಭುವನದ ಭಾಗ್ಯ',
            artUri: Uri.parse('https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F8.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2'),
          tag: MediaItem(
            id: "0",
            title: 'ಸಾಯಿ ಎನ್ನಿರೋ',
            artist: 'ಭುವನದ ಭಾಗ್ಯ',
            artUri: Uri.parse('https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6'),
          ),
        ),
        AudioSource.uri(
          Uri.parse(
              'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2F9.mp3?alt=media&token=b61cb258-e983-4030-8526-9030758e33d2'),
          tag: MediaItem(
            id: "0",
            title: 'ಶ್ರೀ ಸಾಯಿ ನಿನ್ನ ನಂಬಿದೆ',
            artist: 'ಭುವನದ ಭಾಗ್ಯ',
            artUri: Uri.parse('https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Bhuvanada%20Bhagya%2Fbhuvanadabhagya.jpg?alt=media&token=b6335156-54c4-495f-806b-5504beb6b0e6'),
          ),
        ),
      ]);
    } else {}
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            colors: [Color(0xFF144771), Color(0xFF071A2C)],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder(
                stream: _audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource?.tag as MediaItem;
                  return MediaMetaData(
                      imageUrl: metadata.artUri.toString(),
                      title: metadata.title,
                      artist: metadata.artist ?? '');
                }),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return ProgressBar(
                  barHeight: 8,
                  baseBarColor: Colors.grey,
                  bufferedBarColor: Colors.yellow,
                  thumbColor: Colors.yellow,
                  timeLabelTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  progress: positionData?.position ?? Duration.zero,
                  buffered: positionData?.position ?? Duration.zero,
                  total: positionData?.duration ?? Duration.zero,
                  onSeek: _audioPlayer.seek,
                );
              },
            ),
            const SizedBox(height: 20),
            Controls(audioPlayer: _audioPlayer),
          ],
        ),
      ),
    );
  }
}

class MediaMetaData extends StatelessWidget {
  const MediaMetaData(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.artist});
  final String imageUrl, title, artist;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(2, 4),
                blurRadius: 4,
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRect(
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          artist,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}

class Controls extends StatelessWidget {
  const Controls({super.key, required this.audioPlayer});
  final AudioPlayer audioPlayer;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            iconSize: 60,
            color: Colors.white,
            onPressed: audioPlayer.seekToPrevious,
            icon: const Icon(Icons.skip_previous_rounded)),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                onPressed: audioPlayer.play,
                iconSize: 80,
                color: Colors.white,
                icon: const Icon(Icons.play_arrow_rounded),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                onPressed: audioPlayer.pause,
                iconSize: 80,
                color: Colors.white,
                icon: const Icon(Icons.pause_rounded),
              );
            }
            return const Icon(
              Icons.play_arrow_rounded,
              size: 80,
              color: Colors.white,
            );
          },
        ),
        IconButton(
            iconSize: 60,
            color: Colors.white,
            onPressed: audioPlayer.seekToNext,
            icon: const Icon(Icons.skip_next_rounded)),
      ],
    );
  }
}
