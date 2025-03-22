import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/Contact/presentation/pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Social  Links"),
        ),
        body: GradientBackground(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset('assets/img12.jpg'),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        socialMediaBox("Website", Icons.language,
                            'https://sriarjunaavadhoota.org/', context),
                        socialMediaBox(
                            "FaceBook",
                            Icons.facebook,
                            'https://www.facebook.com/profile.php?id=61554090696815',
                            context),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        socialMediaBox(
                            "Instagram",
                            Icons.people,
                            'https://www.instagram.com/sriarjunavadhoothagurumaharaj/',
                            context),
                        socialMediaBox("Contact", Icons.contact_page_outlined,
                            '', context),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        socialMediaBox(
                            "Youtube",
                            Icons.smart_display,
                            'https://www.youtube.com/@srisriarjunavadhoothamaharaj',
                            context),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget socialMediaBox(
      String name, IconData icon, String url, BuildContext context) {
    return InkWell(
      onTap: () async {
        if (name == "Contact") {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const ContactPage()));
        } else {
          Uri webUrl = Uri.parse(url);
          if (!await launchUrl(webUrl)) {
            throw Exception('Could not launch $webUrl');
          }
        }
      },
      child: Container(
        height: 100,
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.blue[900]),
            const SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
