import 'package:arjun_guruji/core/widgets/content_view_page.dart';
import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/Lyrics/data/model/lyrics_model.dart';
import 'package:arjun_guruji/features/Lyrics/domain/usecases/fetch_astottaras_usecase.dart';
import 'package:arjun_guruji/features/Lyrics/presentation/bloc/lyrics_bloc.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
      case 'arati':
        return 'assets/img2.jpg';
      case 'daily bhajans':
        return 'assets/img3.jpg';
      case 'bhaja gurunatham':
        return 'assets/img3.jpg';
      case 'others':
        return 'assets/img3.jpg';
      default:
        return 'assets/img3.jpg';
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
        appBar: AppBar(
          title: const Text('All Lyrics'),
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
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
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

                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: filteredLyrics.length,
                          itemBuilder: (context, index) {
                            final data = filteredLyrics[index];
                            return InkWell(
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
                                      Image.asset(
                                        _getImageForCategory(data.category),
                                        fit: BoxFit.cover,
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
                                          data.title,
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
