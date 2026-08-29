import 'package:arjun_guruji/core/widgets/content_view_page.dart';
import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';
import 'package:arjun_guruji/core/widgets/image_grid_view.dart';
import 'package:arjun_guruji/core/widgets/search_bar.dart';
import 'package:arjun_guruji/features/Astottaras/presentation/bloc/astottara_bloc.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class AllAstottaraPage extends StatefulWidget {
  const AllAstottaraPage({super.key});

  @override
  AllAstottaraPageState createState() => AllAstottaraPageState();
}

class AllAstottaraPageState extends State<AllAstottaraPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AstottarasBloc>()..add(const FetchAllAstottaras()),
      child: Scaffold(
        appBar: GradientAppBar(
          title: 'Astottaras',
        ),
        body: GradientBackground(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                SearchBarWidget(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                  hintText: 'Search astottaras...',
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final bloc = context.read<AstottarasBloc>();
                      bloc.add(const FetchAllAstottaras());
                      await bloc.stream.firstWhere(
                        (state) => state is AstottarasLoaded || state is Error,
                      ).timeout(const Duration(seconds: 4), onTimeout: () => const AstottarasState.initial());
                    },
                    child: BlocBuilder<AstottarasBloc, AstottarasState>(
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
                        } else if (state is AstottarasLoaded) {
                          final filteredAstottara = state.astottaras
                              .where((astottara) => astottara.title
                                  .toLowerCase()
                                  .contains(_searchQuery))
                              .toList()
                            ..sort((a, b) => a.title.compareTo(b.title));
                          return ImageGridView(
                            items: filteredAstottara,
                            getImageUrl: (astottara) => astottara.imageUrl,
                            getImageBytes: (astottara) => astottara.imageBytes,
                            getTitle: (astottara) => astottara.title,
                            getOnTap: (astottara) {
                              if (astottara.content != null) {
                                return () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContentViewPage(
                                        title: astottara.title,
                                        content: astottara.content!,
                                      ),
                                    ),
                                  );
                                };
                              }
                              return null;
                            },
                          );
                        } else if (state is Error) {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: 400,
                              child: Center(
                                child: Text(
                                  state.message,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        } else {
                          return const SingleChildScrollView(
                            physics: AlwaysScrollableScrollPhysics(),
                            child: SizedBox(
                              height: 400,
                              child: Center(
                                child: Text(
                                  'No data available',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    ),
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
