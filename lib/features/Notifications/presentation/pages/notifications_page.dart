import 'package:arjun_guruji/core/widgets/gradient_background.dart';
import 'package:arjun_guruji/features/Notifications/domain/notification.dart';
import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  NotificationsPage({super.key});

  final List<NotificationEntity> notifications = [
    NotificationEntity(
      title: "New Feature Released",
      description: "Check out the new feature in our app.",
      dateTime: DateTime.now().subtract(const Duration(hours: 1)),
      onTapLink: "https://example.com/new-feature",
    ),
    NotificationEntity(
      title: "Maintenance Update",
      description: "Scheduled maintenance on 25th Oct.",
      dateTime: DateTime.now().subtract(const Duration(days: 1)),
      onTapLink: null,
    ),
    NotificationEntity(
      title: "Welcome to the App",
      description: "Thank you for joining us!",
      dateTime: DateTime.now().subtract(const Duration(days: 2)),
      onTapLink: null,
    ),
    NotificationEntity(
      title: "Special Offer",
      description: "Get 50% off on your first purchase.",
      dateTime: DateTime.now().subtract(const Duration(hours: 5)),
      onTapLink: "https://example.com/special-offer",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    notifications.sort((a, b) => b.dateTime.compareTo(a.dateTime));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: GradientBackground(
        child: ListView.builder(
          itemCount: notifications.length,
          itemBuilder: (context, index) {
            final notification = notifications[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      notification.description,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${notification.dateTime.toLocal()}".split(' ')[0],
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    if (notification.onTapLink != null)
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            // Handle navigation to the link
                            final url = notification.onTapLink!;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Opening $url")),
                            );
                          },
                          child: const Text("View Details"),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
