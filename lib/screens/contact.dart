import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget {
  const Contact({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue[900],
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Contact Info",
              style: TextStyle(
                fontSize: 30,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Image.asset('assets/snsdslogo.png'),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              '#36, "ಗೀತನಿಕೇತನ", ಸೋನಾರ್ ಬೀದಿ, ಚಾಮರಾಜ ಮೊಹಲ್ಲಾ, ಮೈಸೂರು - 570024',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Phone: +91-9141075552",
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'Poppins',
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () async {
                    Uri webUrl = Uri.parse("mailto:snsdstrustmysore@gmail.com");
                    if (!await launchUrl(webUrl)) {
                      throw Exception('Could not launch $webUrl');
                    }
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(70)),
                    width: 70,
                    child: const Icon(Icons.mail_outline_outlined),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Uri webUrl = Uri.parse("tel:+919141075552");
                    if (!await launchUrl(webUrl)) {
                      throw Exception('Could not launch $webUrl');
                    }
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(70)),
                    width: 70,
                    child: const Icon(Icons.call_outlined),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    Uri webUrl = Uri.parse("https://maps.app.goo.gl/5yZRd4hzX2zH7MTb8");
                    if (!await launchUrl(webUrl)) {
                      throw Exception('Could not launch $webUrl');
                    }
                  },
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.circular(70)),
                    width: 70,
                    child: const Icon(Icons.maps_home_work_outlined),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
