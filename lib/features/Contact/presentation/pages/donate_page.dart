import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';
import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonatePage extends StatelessWidget {
  const DonatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Donate',
        showBackButton: true,
      ),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                // Trust Info Header Card
                Card(
                  elevation: 4,
                  color: Colors.white.withAlpha((0.08 * 255).toInt()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          'Swarna Nrisimha Datta Sai Peethika Seva Trust',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Support our programs and services',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // QR Code Section
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Scan to Pay / Scan QR Code',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Image.asset(
                          'assets/donate.jpg',
                          height: 220,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // UPI Redirect Button
                ElevatedButton.icon(
                  icon: const Icon(Icons.payment, size: 24),
                  label: const Text(
                    'Donate via UPI App',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final String upiUri = 
                      'upi://pay?'
                      'pa=9448843939@iob'
                      '&pn=Swarna%20Nrisimha%20Datta%20Sai%20Peethika%20Seva%20Trust'
                      '&cu=INR'
                      '&tn=Donation%20to%20Trust';
                    
                    final Uri uri = Uri.parse(upiUri);
                    try {
                      final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
                      if (!launched) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('No UPI apps found. Please scan the QR code or use Bank Transfer details.'),
                              duration: Duration(seconds: 4),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No UPI apps found. Please scan the QR code or use Bank Transfer details.'),
                            duration: Duration(seconds: 4),
                          ),
                        );
                      }
                    }
                  },
                ),
                const SizedBox(height: 20),

                // Bank Details Card
                Card(
                  elevation: 4,
                  color: Colors.white.withAlpha((0.08 * 255).toInt()),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Direct Bank Transfer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const Divider(color: Colors.white30, height: 20),
                        _buildDetailRow('Account Number', '297301000012345'),
                        _buildDetailRow('IFSC Code', 'IOBA0002973'),
                        _buildDetailRow('Branch', 'Srirampura, Mysore'),
                        _buildDetailRow('UPI ID', '9448843939@iob'),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
          const Text(' :  ', style: TextStyle(color: Colors.white70)),
          Expanded(
            flex: 3,
            child: SelectableText(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
