import 'package:arjun_guruji/customwidgets/grid_layout.dart';
import 'package:arjun_guruji/customwidgets/heading.dart';
import 'package:flutter/material.dart';

class BooksSection extends StatelessWidget {
  const BooksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Heading('Books Section', 0),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.blue[900],
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          GridLayout("Books")
        ],
      ),
    );
  }
}
