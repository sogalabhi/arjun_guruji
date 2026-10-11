import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arjun_guruji/core/motion/motion.dart';
import 'package:arjun_guruji/core/motion/page_transitions.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/bloc/global_audio_player_bloc.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/bloc/global_audio_player_event.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/bloc/global_audio_player_state.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/pages/audio_player_page.dart';
import 'package:arjun_guruji/core/services/connectivity_service.dart';

const Color _barColor = Color(0xFF212121);

/// Mini player pinned to the bottom of every screen. Slides up on first play,
/// slides away when stopped, and expands into the full player when tapped.
class GlobalNowPlayingOverlay extends StatefulWidget {
  const GlobalNowPlayingOverlay({super.key});

  @override
  State<GlobalNowPlayingOverlay> createState() => _GlobalNowPlayingOverlayState();
}

class _GlobalNowPlayingOverlayState extends State<GlobalNowPlayingOverlay> {
  final GlobalKey _barKey = GlobalKey();
  // Last state that had a track, so the bar keeps its content while sliding out.
  GlobalAudioPlayerState? _lastWithTrack;
  bool _wasPlayerPageOpen = false;

  void _openPlayer(GlobalAudioPlayerState state) {
    final navContext = ConnectivityService.navigatorKey.currentContext;
    if (navContext == null || state.currentCategory == null) return;

    final page = AudioPlayerPage(
      category: state.currentCategory!,
      index: state.currentIndex,
    );
    final box = _barKey.currentContext?.findRenderObject() as RenderBox?;
    final Route<void> route = box == null || !box.hasSize || Motion.reduced(context)
        ? MaterialPageRoute(builder: (_) => page)
        : ExpandRoute(
            builder: (_) => page,
            sourceRect: box.localToGlobal(Offset.zero) & box.size,
            sourceColor: _barColor,
          );
    Navigator.of(navContext, rootNavigator: true).push(route);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalAudioPlayerBloc, GlobalAudioPlayerState>(
      builder: (context, state) {
        if (state.currentCategory != null) _lastWithTrack = state;
        final shown = _lastWithTrack;
        if (shown == null) return const SizedBox.shrink();

        final visible = state.currentCategory != null && !state.isPlayerPageOpen;
        // Hiding for, or returning from, the full player is instant: the
        // expanding page covers the bar, so a slide would show it twice.
        final instant = state.isPlayerPageOpen || _wasPlayerPageOpen;
        _wasPlayerPageOpen = state.isPlayerPageOpen;
        final duration = instant
            ? Duration.zero
            : Motion.duration(context, Motion.standard);

        return Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: !visible,
            child: AnimatedSlide(
              offset: visible ? Offset.zero : const Offset(0, 1.5),
              duration: duration,
              curve: visible ? MotionCurves.standard : Curves.easeInCubic,
              child: AnimatedOpacity(
                opacity: visible ? 1 : 0,
                duration: duration,
                child: SafeArea(
                  top: false,
                  child: Material(
                    color: Colors.transparent,
                    child: GestureDetector(
                      onTap: () => _openPlayer(state),
                      child: Container(
                        key: _barKey,
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          color: _barColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Row(
                          children: [
                            Expanded(child: _TrackInfo(state: shown)),

                            // Play/Pause
                            IconButton(
                              icon: AnimatedSwitcher(
                                duration: Motion.duration(context, Motion.quick),
                                child: Icon(
                                  shown.isPlaying ? Icons.pause : Icons.play_arrow,
                                  key: ValueKey(shown.isPlaying),
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () {
                                Haptics.tap();
                                if (state.isPlaying) {
                                  context.read<GlobalAudioPlayerBloc>().add(PauseAudio());
                                } else {
                                  context.read<GlobalAudioPlayerBloc>().add(ResumeAudio());
                                }
                              },
                            ),

                            // Close/Stop
                            IconButton(
                              icon: const Icon(Icons.close, color: Colors.grey),
                              onPressed: () {
                                context.read<GlobalAudioPlayerBloc>().add(StopAudio());
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Thumbnail and title; crossfades when the track changes.
class _TrackInfo extends StatelessWidget {
  final GlobalAudioPlayerState state;

  const _TrackInfo({required this.state});

  @override
  Widget build(BuildContext context) {
    final audio = state.currentAudio;
    return AnimatedSwitcher(
      duration: Motion.duration(context, Motion.standard),
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.centerLeft,
        children: [...previous, if (current != null) current],
      ),
      child: Row(
        key: ValueKey('${state.currentCategory?.id}/${state.currentIndex}'),
        children: [
          // Thumbnail
          if (audio?.imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                audio!.imageUrl,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.music_note, color: Colors.white),
              ),
            )
          else
            const Icon(Icons.music_note, color: Colors.white),

          const SizedBox(width: 12),

          // Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  audio?.title ?? 'Unknown Track',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap to return',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
