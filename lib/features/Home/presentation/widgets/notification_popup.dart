import 'package:flutter/material.dart';

class NotificationPopup extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onClose;

  const NotificationPopup({
    super.key,
    required this.notification,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(20),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    notification['title'] ?? '',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: onClose,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                notification['description'] ?? notification['message'] ?? '',
                style: const TextStyle(fontSize: 15),
              ),
              if (notification['image'] != null)
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Image.network(notification['image'], height: 120),
                ),
            ],
          ),
        ),
      ),
    );
  }
}