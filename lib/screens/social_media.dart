import 'package:arjun_guruji/customwidgets/heading.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Heading('Social Media Links', 0),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        backgroundColor: Colors.blue[900],
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/img12.jpg'),
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      box("Website", Icons.language,
                          'https://sriarjunaavadhoota.org/', context),
                      box(
                          "FaceBook",
                          Icons.facebook,
                          'https://www.facebook.com/profile.php?id=61554090696815',
                          context),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      box(
                          "Instagram",
                          Icons.people,
                          'https://www.instagram.com/sriarjunavadhoothagurumaharaj/',
                          context),
                      box("Contact", Icons.contact_page_outlined, '', context),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      box(
                          "Youtube",
                          Icons.smart_display ,
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
    );
  }
}

Widget box(String name, IconData icon, String url, BuildContext context) {
  return InkWell(
    onTap: () async {
      if (name == "Contact") {
        Navigator.pushNamed(context, '/Contactpage');
      } else {
        Uri webUrl = Uri.parse(url);
        if (!await launchUrl(webUrl)) {
          throw Exception('Could not launch $webUrl');
        }
        // Navigator.of(context).push(MaterialPageRoute(
        //     builder: (context) => WebViewScreen(
        //           url: url,
        //         )));
      }
    },
    child: Container(
      height: 100,
      width: 150,
      decoration: BoxDecoration(
        color: Colors.yellow,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(icon),
          Text(name),
        ],
      ),
    ),
  );
}
