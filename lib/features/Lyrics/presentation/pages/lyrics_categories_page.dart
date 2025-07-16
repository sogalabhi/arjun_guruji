import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/Lyrics/data/model/lyrics_model.dart';
import 'package:arjun_guruji/features/Lyrics/domain/usecases/fetch_astottaras_usecase.dart';
import 'package:arjun_guruji/features/Lyrics/presentation/bloc/lyrics_bloc.dart';
import 'package:arjun_guruji/features/Lyrics/presentation/pages/lyrics_listview_page.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';

class AllLyricsPage extends StatefulWidget {
  const AllLyricsPage({super.key});

  @override
  AllLyricsPageState createState() => AllLyricsPageState();
}

class AllLyricsPageState extends State<AllLyricsPage> {
  String _getImageForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'ನಿತ್ಯ ಭಜನೆಗಳು':
        return 'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2F12.jpg?alt=media&token=e303f0bc-9117-49ba-ac8f-46cc6f7ab17e';
      case 'ಇತರೆ':
        return 'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2F17.jpg?alt=media&token=9484a469-da31-4ab8-be68-7a1e02abd384';
      case 'ಆರತಿ':
        return 'https://firebasestorage.googleapis.com/v0/b/arjun-guruji-app.appspot.com/o/Gallery%2Fimg2.jpg?alt=media&token=c3675c3f-3e1c-43ef-b33f-504edf8b8f55';
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
          title: 'Lyrics Categories',
        ),
        body: GradientBackground(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Expanded(
                  child: BlocBuilder<LyricsBloc, LyricsState>(
                    builder: (context, state) {
                      if (state is Loading) {
                        return GridView.builder(
                          itemCount: 6,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            return Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state is LyricsLoaded) {
                        final filteredLyrics = state.lyrics
                            .map((e) => e.category)
                            .toSet()
                            .toList()
                          ..sort((a, b) => a.compareTo(b));
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
                            final category = filteredLyrics[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LyricsListPage(
                                      category: category,
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
                                      Image.network(
                                        _getImageForCategory(category),
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
                                          category,
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
                        return const Center(
                            child: Text('No Category available'));
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
