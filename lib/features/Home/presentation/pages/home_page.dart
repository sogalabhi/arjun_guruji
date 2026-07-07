import 'package:arjun_guruji/core/widgets/gradient_app_bar.dart';
import 'package:arjun_guruji/features/Home/presentation/widgets/home_page_content.dart';
import 'package:arjun_guruji/features/Notifications/presentation/pages/notifications_page.dart';
import 'package:arjun_guruji/features/Notifications/domain/notification.dart';
import 'package:arjun_guruji/features/Notifications/domain/usecases/fetch_latest_notification_usecase.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/notification_popup.dart';
import 'package:arjun_guruji/injection_container.dart';
import 'package:upgrader/upgrader.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showNotificationPopup = false;
  NotificationEntity? latestNotification;

  @override
  void initState() {
    super.initState();
    _checkAndShowLatestNotification();
  }

  Future<void> _checkAndShowLatestNotification() async {
    final fetchLatestNotificationUseCase = sl<FetchLatestNotificationUseCase>();
    final result = await fetchLatestNotificationUseCase(NoParams());
    result.fold(
      (failure) => null, // Ignore failures silently on startup
      (notification) async {
        if (notification != null) {
          final notificationId = notification.id;
          final prefs = await SharedPreferences.getInstance();
          final dismissed =
              prefs.getBool('latest_notification_dismissed_$notificationId') ??
                  false;
          if (!dismissed) {
            setState(() {
              showNotificationPopup = true;
              latestNotification = notification;
            });
          }
        }
      },
    );
  }

  void _dismissNotificationPopup() async {
    if (latestNotification != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(
          'latest_notification_dismissed_${latestNotification!.id}', true);
    }
    setState(() {
      showNotificationPopup = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return UpgradeAlert(
      child: Scaffold(
        appBar: GradientAppBar(
          title: "Arjun Guruji",
          actions: [
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const NotificationsPage(),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            const HomePageContent(),
            if (showNotificationPopup && latestNotification != null)
              NotificationPopup(
                notification: latestNotification!,
                onClose: _dismissNotificationPopup,
              ),
          ],
        ),
      ),
    );
  }
}
