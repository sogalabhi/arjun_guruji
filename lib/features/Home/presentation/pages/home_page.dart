import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/Admin/presentation/pages/admin_login_page.dart';
import 'package:arjun_guruji/features/Astottaras/presentation/pages/all_astottara_page.dart';
import 'package:arjun_guruji/features/AudioPlayer/presentation/pages/audio_categories_page.dart';
import 'package:arjun_guruji/features/Books/presentation/pages/all_books_page.dart';
import 'package:arjun_guruji/features/Contact/presentation/pages/social_media_page.dart';
import 'package:arjun_guruji/features/EventManagement/presentation/pages/event_list_page.dart';
import 'package:arjun_guruji/features/Gallery/presentation/pages/gallery_page.dart';
import 'package:arjun_guruji/features/Lyrics/presentation/pages/lyrics_categories_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    final List<Map<String, dynamic>> menuItems = [
      {
        "title": "Books",
        "subtitle": "Books",
        "imagePath": 'assets/mainbook.png',
        "route": () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => const AllBooksPage()));
        }
      },
      {
        "title": "Astottara",
        "subtitle": "Astottara",
        "imagePath": 'assets/mainastottaras.png',
        "route": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AllAstottaraPage()));
        }
      },
      {
        "title": "Audio",
        "subtitle": "Audio",
        "imagePath": 'assets/mainaudio.png',
        "route": () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AudioCategoriesPage()));
        }
      },
      {
        "title": "Lyrics",
        "subtitle": "Lyrics",
        "imagePath": 'assets/mainlyrics.png',
        "route": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AllLyricsPage()));
        }
      },
      {
        "title": "Events",
        "subtitle": "Events",
        "imagePath": 'assets/maingallery.png',
        "route": () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => EventListPage()));
        }
      },
      {
        "title": "About",
        "subtitle": "About",
        "imagePath": 'assets/mainlinks.png',
        "route": () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const SocialMediaPage()));
        }
      },
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
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
                child: GestureDetector(
                  onDoubleTapDown: (details) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const AdminLoginPage()));
                  },
                  child: Image.asset(
                    "assets/mainimg.png",
                    height: screenHeight / 3.4,
                    width: screenWidth / 1.4,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth < 600 ? 2 : 4,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                      childAspectRatio: 1,
                    ),
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      final item = menuItems[index];
                      return GestureDetector(
                        onTap: item['route'],
                        child: Card(
                          color: const Color.fromARGB(255, 255, 209, 70),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                item['imagePath'],
                                height: 50,
                                width: 50,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
