import 'package:arjun_guruji/core/widgets/content_view_page.dart';
import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:flutter/material.dart';

class ChaptersListPage extends StatefulWidget {
  final Book book;

  const ChaptersListPage({super.key, required this.book});

  @override
  ChaptersListPageState createState() => ChaptersListPageState();
}

class ChaptersListPageState extends State<ChaptersListPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredChapters = [];

  @override
  void initState() {
    super.initState();
    _filteredChapters = widget.book.chapters ?? [];
    _searchController.addListener(_filterChapters);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterChapters);
    _searchController.dispose();
    super.dispose();
  }

  void _filterChapters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredChapters = widget.book.chapters!
          .where(
              (chapter) => chapter['chapterName'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
      ),
      body: GradientBackground(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search chapters...',
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
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _filteredChapters.length,
                itemBuilder: (context, index) {
                  final chapter = _filteredChapters[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListTile(
                      title: Text(
                        '${index + 1}. ${chapter['chapterName']}',
                        style: const TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContentViewPage(
                              title: widget.book.title,
                              chapterName: chapter['chapterName'],
                              content: chapter['content'],
                            ),
                          ),
                        );
                      },
                    ),
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
