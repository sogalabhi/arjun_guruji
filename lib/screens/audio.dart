import 'package:arjun_guruji/customwidgets/Gridlayout.dart';
import 'package:arjun_guruji/customwidgets/Heading.dart';
import 'package:flutter/material.dart';

class Audio extends StatelessWidget {
  const Audio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Heading('Audio Section', 0),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.blue[900],
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/img11.jpg',
                  height: 250,
                )),
          ),
          GridLayout("Audio"),
        ],
      ),
    );
  }
}
