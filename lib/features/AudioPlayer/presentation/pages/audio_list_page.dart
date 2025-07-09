import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/pages/audio_player_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:arjun_guruji/features/AudioPlayer/domain/entity/category.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';

class AudioListPage extends StatelessWidget {
  final CategoryEntity category;

  const AudioListPage({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Audio List',
      ),
      body: GradientBackground(
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Hero(
                tag: 'category-image-${category.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: CachedNetworkImage(
                    imageUrl: category.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: category.audios.length,
                itemBuilder: (context, index) {
                  final audio = category.audios[index];
                  return Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.audiotrack,
                          color: Colors.white,
                        ),
                        title: Text(
                          audio.title,
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          audio.category,
                          style: const TextStyle(color: Colors.white),
                        ),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return AudioPlayerPage(
                              audio: audio,
                              category: category,
                              index: index,
                            );
                          }));
                        },
                        tileColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        hoverColor: Colors.grey[700],
                        splashColor: Colors.blueAccent,
                      ),
                      const Divider(
                        color: Colors.white,
                        thickness: 1.0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
