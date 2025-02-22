import 'package:arjun_guruji/features/Books/domain/entity/book.dart';
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
          );
        },
      ),
    );
  }
}
