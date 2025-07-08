import 'package:flutter/material.dart';

class NotificationPopup extends StatelessWidget {
  final GlobalKey buttonKey;
  final VoidCallback onClose;
  
  final List<Map<String, dynamic>> notifications = [
    {
      'title': 'New Book Added',
      'message': 'The Bhagavad Gita is now available',
      'time': '2 hours ago',
    },
    {
      'title': 'Event Reminder',
      'message': 'Ram Navami celebration starts tomorrow',
      'time': '1 day ago',
    },
    {
      'title': 'App Update',
      'message': 'New version 1.2.0 is available',
      'time': '3 days ago',
    },
  ];

  NotificationPopup({
    super.key,
    required this.buttonKey,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final RenderBox renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox;
    final buttonPosition = renderBox.localToGlobal(Offset.zero);
    final buttonSize = renderBox.size;

    return Positioned(
      top: buttonPosition.dy + buttonSize.height + 5,
      right: MediaQuery.of(context).size.width - buttonPosition.dx - buttonSize.width,
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 300,
          constraints: const BoxConstraints(maxHeight: 400),
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
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              if (notifications.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No notifications available'),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];
                    return ListTile(
                      title: Text(notification['title']),
                      subtitle: Text(notification['message']),
                      trailing: Text(
                        notification['time'],
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}