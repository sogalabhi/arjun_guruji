import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/notification_model.dart';

class NotificationsRemoteDataSource {
  final FirebaseFirestore firestore;

  NotificationsRemoteDataSource({FirebaseFirestore? firestoreInstance})
      : firestore = firestoreInstance ?? FirebaseFirestore.instance;

  Future<List<NotificationModel>> fetchNotifications() async {
    final querySnapshot = await firestore
        .collection('Notifications')
        .where('isVisible', isEqualTo: true)
        .get();

    final notifications = querySnapshot.docs.map((doc) {
      final data = doc.data();
      return NotificationModel(
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        dateTime: (data['dateTime'] as Timestamp).toDate(),
        image: data['image'],
        onTapLink: data['onTapLink'],
      );
    }).toList();

    notifications.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    return notifications;
  }

  Future<Map<String, dynamic>?> fetchLatestNotification() async {
    final query = await firestore
        .collection('Notifications')
        .where('isVisible', isEqualTo: true)
        .get();
    if (query.docs.isNotEmpty) {
      final docs = query.docs;
      
      // Filter out notifications with past dateTime
      final now = DateTime.now();
      final futureNotifications = docs.where((doc) {
        final notificationDateTime = (doc['dateTime'] as Timestamp).toDate();
        return notificationDateTime.isAfter(now);
      }).toList();
      
      if (futureNotifications.isEmpty) {
        return null; // No future notifications found
      }
      
      // Sort by dateTime (latest first)
      futureNotifications.sort((a, b) => (b['dateTime'] as Timestamp).compareTo(a['dateTime'] as Timestamp));
      
      final data = futureNotifications.first.data();
      data['id'] = futureNotifications.first.id;
      return data;
    }
    return null;
  }
} 