import 'package:arjun_guruji/customwidgets/Heading.dart';
import 'package:arjun_guruji/customwidgets/Gridlayout.dart';
import 'package:flutter/material.dart';

class AstottaraSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading('Astottara Section', 0),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.blue[900],
      body: Column(
        children: [
          GridLayout("Astottara"),
        ],
      ),
    );
  }
}
