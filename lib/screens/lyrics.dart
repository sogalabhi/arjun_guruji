import 'package:arjun_guruji/customwidgets/Gridlayout.dart';
import 'package:arjun_guruji/customwidgets/Heading.dart';
import 'package:flutter/material.dart';

class Lyrics extends StatelessWidget {
  const Lyrics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Heading("Lyrics Section", 0),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 16,
              ),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/img3.jpg',
                    height: 300,
                  )),
            ),
            GridLayout("Lyrics")
          ],
        ),
      ),
    );
  }
}
