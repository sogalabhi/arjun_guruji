import 'package:arjun_guruji/customwidgets/Heading.dart';
import 'package:arjun_guruji/customwidgets/galleryview.dart';
import 'package:flutter/material.dart';

class Gallery extends StatelessWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        title: Heading('Gallery', 0),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
        backgroundColor: Colors.blue[900],
        body: Column(
          children: [
            GalleryView(),
          ],
        ),
      ),
    );
  }
}
