import 'package:arjun_guruji/core/widgets/content_view_page.dart';
import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/core/widgets/image_grid_view.dart';
import 'package:arjun_guruji/core/widgets/search_bar.dart';
import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:arjun_guruji/features/Books/domain/usecases/books_usecase.dart';
import 'package:arjun_guruji/features/Books/presentation/bloc/books_bloc.dart';
import 'package:arjun_guruji/features/Books/presentation/pages/chapters_list_page.dart';
import 'package:arjun_guruji/features/Books/presentation/pages/pdf_view_page.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shimmer/shimmer.dart';

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
      create: (context) => BooksBloc(
        fetchBooksUseCase: sl<FetchBooksUseCase>(),
        booksBox: Hive.box<BookModel>('booksBox'),
        connectivity: sl(),
      )..add(const FetchAllBooks()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('All Books'),
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
                      context.read<BooksBloc>().add(const FetchAllBooks());
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
                              .where((book) =>
                                  book.title.toLowerCase().contains(_searchQuery))
                              .toList();
                          return ImageGridView(
                            items: filteredBooks,
                            getImageUrl: (book) => book.imageUrl,
                            getTitle: (book) => book.title,
                            getOnTap: (book) {
                              if (book.bookType == 'chapters' &&
                                  book.chapters != null) {
                                return () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChaptersListPage(book: book),
                                    ),
                                  );
                                };
                              } else if (book.bookType == 'html' &&
                                  book.content != null) {
                                return () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContentViewPage(
                                        title: book.title,
                                        content: book.content!,
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
                          return Center(
                            child: Text(
                              state.message,
                              style: const TextStyle(color: Colors.white),
                            ),
                          );
                        } else {
                          return const Center(child: Text('No data available'));
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

  Widget buildBookImage(BookModel book) {
    if (book.imageBytes != null) {
      return Image.memory(book.imageBytes!);
    } else {
      return Image.network(book.imageUrl);
    }
  }
}
