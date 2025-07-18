import 'package:arjun_guruji/core/widgets/content_view_page.dart';
import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';
import 'package:arjun_guruji/features/Lyrics/data/model/lyrics_model.dart';
import 'package:arjun_guruji/features/Lyrics/domain/usecases/fetch_astottaras_usecase.dart';
import 'package:arjun_guruji/features/Lyrics/presentation/bloc/lyrics_bloc.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';

class LyricsListPage extends StatefulWidget {
  final String category;
  const LyricsListPage({super.key, required this.category});

  @override
  LyricsListPageState createState() => LyricsListPageState();
}

class LyricsListPageState extends State<LyricsListPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  String _getImageForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'ನಿತ್ಯ ಭಜನೆಗಳು':
        return 'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2F12.jpg?alt=media&token=e303f0bc-9117-49ba-ac8f-46cc6f7ab17e';
      case 'ಇತರೆ':
        return 'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2F17.jpg?alt=media&token=9484a469-da31-4ab8-be68-7a1e02abd384';
      case 'ಆರತಿ':
        return 'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Faarti.png?alt=media&token=3b5d2065-f4a2-40cd-8456-c560a86b474f';
      default:
        return 'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Faarti.png?alt=media&token=3b5d2065-f4a2-40cd-8456-c560a86b474f';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LyricsBloc(
        fetchLyricsUseCase: sl<FetchLyricsUseCase>(),
        lyricsBox: Hive.box<LyricsModel>('lyricsBox'),
        connectivity: sl(),
      )..add(const LyricsEvent.fetchAllLyrics()),
      child: Scaffold(
        appBar: GradientAppBar(
          title: 'Lyrics',
        ),
        body: GradientBackground(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search lyrics...',
                    hintStyle: TextStyle(color: Colors.grey[400]),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                    filled: true,
                    fillColor: Colors.white.withAlpha((0.1 * 255).toInt()),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<LyricsBloc, LyricsState>(
                    builder: (context, state) {
                      if (state is Loading) {
                        return Center(
                          child: Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: 60,
                              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      } else if (state is LyricsLoaded) {
                        final filteredLyrics = state.lyrics
                            .where(
                              (lyrics) =>
                                  lyrics.category.toLowerCase() ==
                                      widget.category.toLowerCase() &&
                                  lyrics.title
                                      .toLowerCase()
                                      .contains(_searchQuery),
                            )
                            .toList();

                        return ListView.separated(
                          itemCount: filteredLyrics.length,
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder: (context, index) {
                            final data = filteredLyrics[index];
                            return ListTile(
                              leading: Image.network(
                                _getImageForCategory(data.category),
                                width: 48,
                                height: 48,
                                fit: BoxFit.cover,
                              ),
                              title: Text(
                                data.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ContentViewPage(
                                      content: data.content ?? '',
                                      title: data.title,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        );
                      } else if (state is Error) {
                        return Center(
                          child: Text(
                            state.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      } else {
                        return const Center(child: Text('No data available'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
