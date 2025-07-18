import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/Contact/presentation/pages/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: GradientAppBar(
          title: 'Social Media',
        ),
        body: GradientBackground(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
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
                              'https://www.facebook.com/share/16dVbzvr8L/',
                              context),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          socialMediaBox(
                              "Instagram",
                              Icons.camera_alt,
                              'https://www.instagram.com/srisriarjunavadhoothamaharaj?igsh=MTNsNGVyMzNscHVxNg==',
                              context),
                          socialMediaBox("Contact", Icons.contact_page_outlined,
                              '', context),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          socialMediaBox(
                              "WhatsApp",
                              Icons.chat,
                              'https://whatsapp.com/channel/0029VaxAnryLSmbiJv5Elm0T',
                              context),
                          socialMediaBox(
                              "Threads",
                              Icons.forum,
                              'https://www.threads.net/@srisriarjunavadhoothamaharaj',
                              context),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          socialMediaBox(
                              "YouTube",
                              Icons.smart_display,
                              'https://youtube.com/@srisriarjunavadhoothamaharaj?si=DakdQ0KQIinug3ac',
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
      ),
    );
  }

  Widget socialMediaBox(
      String name, IconData icon, String url, BuildContext context) {
    return InkWell(
      onTap: () async {
        if (name == "Contact") {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const ContactPage()));
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
