import 'package:arjun_guruji/customwidgets/Gridlayout.dart';
import 'package:arjun_guruji/customwidgets/Heading.dart';
import 'package:flutter/material.dart';

class BooksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading('Books Section', 0),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.blue[900],
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          GridLayout("Books")
        ],
      ),
    );
  }
}
