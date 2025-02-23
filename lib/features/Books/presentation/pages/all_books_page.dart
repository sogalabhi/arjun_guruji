import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/Books/data/model/book_model.dart';
import 'package:arjun_guruji/features/Books/domain/usecases/FetchBooksUseCase.dart';
import 'package:arjun_guruji/features/Books/presentation/bloc/books_bloc.dart';
import 'package:arjun_guruji/features/Books/presentation/pages/chapters_list_page.dart';
import 'package:arjun_guruji/features/Books/presentation/pages/content_view_page.dart';
import 'package:arjun_guruji/features/Books/presentation/pages/pdf_view_page.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search books...',
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
                  child: BlocBuilder<BooksBloc, BooksState>(
                    builder: (context, state) {
                      if (state is Loading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        );
                      } else if (state is BooksLoaded) {
                        final filteredBooks = state.books
                            .where((book) =>
                                book.title.toLowerCase().contains(_searchQuery))
                            .toList();
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 0.7,
                          ),
                          itemCount: filteredBooks.length,
                          itemBuilder: (context, index) {
                            final data = filteredBooks[index];
                            return InkWell(
                              onTap: () {
                                if (data.bookType == 'html' &&
                                    data.chapters != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChaptersListPage(
                                        book: data,
                                      ),
                                    ),
                                  );
                                } else if (data.bookType == 'html' &&
                                    data.content != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContentViewPage(
                                        title: data.title,
                                        content: data.content!,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => PDFViewerPage(
                                        book: data,
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey
                                          .withAlpha((0.5 * 255).toInt()),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Image.asset(data.imageUrl),
                                    Text(
                                      data.title,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
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
