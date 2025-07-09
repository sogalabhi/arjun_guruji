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
      case 'arti':
        return 'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55';
      case 'daily bhajans':
        return 'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2F12.jpg?alt=media&token=e303f0bc-9117-49ba-ac8f-46cc6f7ab17e';
      case 'others':
        return 'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2F17.jpg?alt=media&token=9484a469-da31-4ab8-be68-7a1e02abd384';
      default:
        return 'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55';
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
