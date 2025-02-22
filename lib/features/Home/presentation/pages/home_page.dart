import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/Home/presentation/widgets/build_grid.dart';
import 'package:arjun_guruji/features/Home/models.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    final List<Items> myList = [
      Items("Books", "Books", 'assets/mainbook.png', 'txt', () {
        Navigator.pushNamed(context, '/Books');
      }),
      Items("Astottara", "Astottara", 'assets/mainastottaras.png', 'txt', () {
        Navigator.pushNamed(context, '/astottara');
      }),
      Items("Audio", "Audio", 'assets/mainaudio.png', 'txt', () {
        Navigator.pushNamed(context, '/audio');
      }),
      Items("Lyrics", "Lyrics", 'assets/mainlyrics.png', 'txt', () {
        Navigator.pushNamed(context, '/lyrics');
      }),
      Items("Gallery", "Gallery", 'assets/maingallery.png', 'txt', () {
        Navigator.pushNamed(context, '/gallery');
      }),
      Items("Contact", "Contact", 'assets/mainlinks.png', 'txt', () {
        Navigator.pushNamed(context, '/contact');
      }),
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              const SizedBox(height: 20),
              const Center(
                child: Text(
                  "Arjun Guruji",
                  style: TextStyle(
                    fontFamily: 'samarkan',
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Image.asset(
                  "assets/mainimg.png",
                  height: height / 3.4,
                  width: width / 1.4,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 30),
              buildGrid(myList, width, height),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
