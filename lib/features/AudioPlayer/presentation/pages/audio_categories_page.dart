import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/pages/audio_list_page.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/bloc/audio_bloc.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';

class AudioCategoriesPage extends StatelessWidget {
  const AudioCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Audio Categories',
      ),
      body: BlocProvider(
        create: (context) => sl<AudioBloc>()..add(const FetchAllAudio()),
        child: GradientBackground(
          child: Column(
            children: [
              const SizedBox(
                height: 16.0,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: BlocBuilder<AudioBloc, AudioState>(
                    builder: (context, state) {
                      if (state is Loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is AudioLoaded) {
                        final categories = state.audios;
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.0,
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        AudioListPage(category: category),
                                  ),
                                );
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 5,
                                        offset: Offset(2, 2))
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      Hero(
                                        tag: 'category-image-${category.id}',
                                        child: CachedNetworkImage(
                                          imageUrl: category.imageUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black.withAlpha(
                                                  (0.6 * 255).toInt()),
                                              Colors.transparent
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 10,
                                        left: 10,
                                        child: Text(
                                          category.name,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is Error) {
                        return Center(
                            child: Text(
                          state.message,
                          style: const TextStyle(color: Colors.white),
                        ));
                      } else {
                        return const Center(
                            child: Text('Something went wrong!',
                                style: TextStyle(color: Colors.white)));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
