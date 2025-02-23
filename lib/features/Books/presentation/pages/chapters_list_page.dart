import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
import 'package:arjun_guruji/features/Books/presentation/pages/content_view_page.dart';
import 'package:flutter/material.dart';

class ChaptersListPage extends StatelessWidget {
  final Book book;

  const ChaptersListPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(book.title),
      ),
      body: ListView.builder(
        itemCount: book.chapters?.length ?? 0,
        itemBuilder: (context, index) {
          final chapter = book.chapters![index];
          return ListTile(
            title: Text(chapter['chapterName']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ContentViewPage(
                    title: book.title,
                    content: book.chapters![index]['content'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
