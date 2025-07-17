import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Contact',
        showBackButton: true,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Image.asset('assets/snsdslogo.png', height: 200),
                ),
                const SizedBox(height: 20),
                const Text(
                  '#36, "ಗೀತನಿಕೇತನ", ಸೋನಾರ್ ಬೀದಿ, ಚಾಮರಾಜ ಮೊಹಲ್ಲಾ, ಮೈಸೂರು - 570024',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Phone: +91-9141075552",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  icon: Icon(Icons.volunteer_activism),
                  label: Text('Donate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Bank & UPI Details'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 12),
                            const Text('Swarna Nrisimha Datta Sai Peethika Seva Trust'),
                            const Text('A/C #: 297301000012345'),
                            const Text('IFSC: IOBA0002973'),
                            const Text('Branch: Srirampura, Mysore'),
                            const SizedBox(height: 16),
                            const Text('UPI ID: 9448843939@iob'),
                            const SizedBox(height: 8),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    contactIcon(Icons.mail_outline_outlined, "mailto:snsdstrustmysore@gmail.com"),
                    contactIcon(Icons.call_outlined, "tel:+919141075552"),
                    contactIcon(Icons.maps_home_work_outlined, "https://maps.app.goo.gl/5yZRd4hzX2zH7MTb8"),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget contactIcon(IconData icon, String url) {
    return InkWell(
      onTap: () async {
        Uri webUrl = Uri.parse(url);
        if (!await launchUrl(webUrl)) {
          throw Exception('Could not launch $webUrl');
        }
      },
      child: Container(
        height: 70,
        width: 70,
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
        child: Icon(icon, size: 40, color: Colors.blue[900]),
      ),
    );
  }
}
