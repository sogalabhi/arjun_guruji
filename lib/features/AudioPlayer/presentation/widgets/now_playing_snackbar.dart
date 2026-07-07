import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/bloc/global_audio_player_bloc.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/bloc/global_audio_player_event.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/bloc/global_audio_player_state.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/pages/audio_player_page.dart';
import 'package:arjun_guruji/core/services/connectivity_service.dart';

class GlobalNowPlayingOverlay extends StatelessWidget {
  const GlobalNowPlayingOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GlobalAudioPlayerBloc, GlobalAudioPlayerState>(
      builder: (context, state) {
        // Only show if there's a category and something is playing or paused but active
        if (state.currentCategory == null) return const SizedBox.shrink();
        
        // Hide if the user is currently looking at the full player page
        if (state.isPlayerPageOpen) return const SizedBox.shrink();

        return Positioned(
          left: 0,
          right: 0,
          bottom: 0, // Above bottom nav if any, but since it's global, it'll sit at the very bottom
          child: SafeArea(
            child: Material(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  // Navigate to the player page using global context
                  if (state.currentCategory != null) {
                    final navContext = ConnectivityService.navigatorKey.currentContext;
                    if (navContext != null) {
                      Navigator.of(navContext, rootNavigator: true).push(
                        MaterialPageRoute(
                          builder: (_) => AudioPlayerPage(
                            category: state.currentCategory!,
                            index: state.currentIndex,
                          ),
                        ),
                      );
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      // Thumbnail
                      if (state.currentAudio?.imageUrl != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            state.currentAudio!.imageUrl,
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
                              state.currentAudio?.title ?? 'Unknown Track',
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
                      
                      // Play/Pause
                      IconButton(
                        icon: Icon(
                          state.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white,
                        ),
                        onPressed: () {
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
        );
      },
    );
  }
}
