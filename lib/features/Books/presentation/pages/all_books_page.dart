import 'package:arjun_guruji/core/reader/reader_page.dart';
import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/core/widgets/image_grid_view.dart';
import 'package:arjun_guruji/core/widgets/search_bar.dart';
import 'package:arjun_guruji/features/Books/presentation/bloc/books_bloc.dart';
import 'package:arjun_guruji/features/Books/presentation/pages/pdf_view_page.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';

class AllBooksPage extends StatefulWidget {
  const AllBooksPage({super.key});

  @override
  AllBooksPageState createState() => AllBooksPageState();
}

class AllBooksPageState extends State<AllBooksPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BooksBloc>()..add(const FetchAllBooks()),
      child: Scaffold(
        appBar: GradientAppBar(
          title: 'All Books',
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
                  hintText: 'Search books...',
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      final bloc = context.read<BooksBloc>();
                      bloc.add(const FetchAllBooks());
                      await bloc.stream
                          .firstWhere(
                            (state) => state is BooksLoaded || state is Error,
                          )
                          .timeout(const Duration(seconds: 4),
                              onTimeout: () => const BooksState.initial());
                    },
                    child: BlocBuilder<BooksBloc, BooksState>(
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
                        } else if (state is BooksLoaded) {
                          final filteredBooks = state.books
                              .where((book) => book.title
                                  .toLowerCase()
                                  .contains(_searchQuery))
                              .toList();
                          return ImageGridView(
                            items: filteredBooks,
                            getImageUrl: (book) => book.imageUrl,
                            getImageBytes: (book) => book.imageBytes,
                            getTitle: (book) => book.title,
                            getOnTap: (book) {
                              if (book.bookType == 'chapters' &&
                                  book.chapters != null) {
                                // Each chapter is a section of one reader, so
                                // chapter books get the same contents screen.
                                final chapters = [
                                  for (final c in book.chapters!)
                                    (
                                      name: c['chapterName'] as String? ?? '',
                                      content: c['content'] as String? ?? '',
                                    ),
                                ];
                                return () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReaderPage(
                                        kind: 'book',
                                        title: book.title,
                                        chapterName: chapters.length == 1
                                            ? chapters.single.name
                                            : null,
                                        content: chapters.length == 1
                                            ? chapters.single.content
                                            : '',
                                        chapters: chapters.length > 1
                                            ? chapters
                                            : null,
                                      ),
                                    ),
                                  );
                                };
                              } else if (book.bookType == 'html' &&
                                  book.htmlContent != null) {
                                return () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ReaderPage(
                                        kind: 'book',
                                        title: book.title,
                                        content: book.htmlContent!,
                                      ),
                                    ),
                                  );
                                };
                              } else {
                                return () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PDFViewerPage(book: book),
                                    ),
                                  );
                                };
                              }
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
