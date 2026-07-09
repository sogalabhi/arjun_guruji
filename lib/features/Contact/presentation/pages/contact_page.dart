import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri webUrl = Uri.parse(url);
    if (!await launchUrl(webUrl)) {
      throw Exception('Could not launch $webUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const GradientAppBar(
        title: 'Contact Us',
        showBackButton: true,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 16.0),
                    child: Image.asset('assets/snsdslogo.png', height: 160),
                  ),
                ),
                // General Contact Info (Phone & Email)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0x14FFFFFF),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x1EFFFFFF)),
                  ),
                  child: Row(
                    children: [
                      // Phone contact
                      Expanded(
                        child: InkWell(
                          onTap: () => _launchURL("tel:+919141075552"),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Color(0x1AFFFFFF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.phone_outlined,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Call Us",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "+91 91410 75552",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Divider line
                      Container(
                        height: 60,
                        width: 1,
                        color: const Color(0x26FFFFFF),
                      ),
                      // Email contact
                      Expanded(
                        child: InkWell(
                          onTap: () => _launchURL("mailto:snsdstrustmysore@gmail.com"),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(
                                  color: Color(0x1AFFFFFF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.mail_outline_outlined,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Email Us",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "snsdstrustmysore@gmail.com",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 11,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.only(left: 4.0, bottom: 12.0),
                  child: Text(
                    "Our Locations",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                // Gurunivasa Address
                _buildLocationCard(
                  title: 'Gurunivasa',
                  address: '#36, "ಗೀತನಿಕೇತನ", ಸೋನಾರ್ ಬೀದಿ, ಚಾಮರಾಜ ಮೊಹಲ್ಲಾ, ಮೈಸೂರು - 570024',
                  mapUrl: 'https://maps.app.goo.gl/5yZRd4hzX2zH7MTb8',
                  icon: Icons.home_outlined,
                ),
                // Ashrama Address
                _buildLocationCard(
                  title: 'Shree Venkatarjuna Dhyana Mandira (Ashrama)',
                  address: 'Shree Venkatarjuna Dhyana Mandira, Ranganathapur, Harohalli (J), Karnataka 570028',
                  mapUrl: 'https://maps.app.goo.gl/j74gF3VznGutsni5A',
                  icon: Icons.spa_outlined,
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationCard({
    required String title,
    required String address,
    required String mapUrl,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0x14FFFFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0x1EFFFFFF)), 
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0x1AFFFFFF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: Colors.amber, size: 24),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              address,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _launchURL(mapUrl),
                icon: const Icon(Icons.map_outlined, size: 18, color: Colors.black),
                label: const Text(
                  "View on Google Maps",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
