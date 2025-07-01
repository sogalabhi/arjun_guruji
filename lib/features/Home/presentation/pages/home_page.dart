import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';
import 'package:arjun_guruji/features/Home/presentation/widgets/home_page_content.dart';
import 'package:arjun_guruji/features/Notifications/presentation/pages/notifications_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: "Arjun Guruji",
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => NotificationsPage(),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const HomePageContent(),
        ],
      ),
    );
  }
}
