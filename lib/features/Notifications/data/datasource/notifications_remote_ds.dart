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
        id: doc.id,
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

  Future<NotificationModel?> fetchLatestNotification() async {
    final querySnapshot = await firestore
        .collection('Notifications')
        .where('isVisible', isEqualTo: true)
        .get();
    if (querySnapshot.docs.isEmpty) return null;

    final now = DateTime.now();
    final futureDocs = querySnapshot.docs.where((doc) {
      final data = doc.data();
      if (data['dateTime'] == null) return false;
      final dateTime = (data['dateTime'] as Timestamp).toDate();
      return dateTime.isAfter(now);
    }).toList();

    if (futureDocs.isEmpty) return null;

    // Sort by dateTime (latest first)
    futureDocs.sort((a, b) {
      final aTime = (a.data()['dateTime'] as Timestamp).toDate();
      final bTime = (b.data()['dateTime'] as Timestamp).toDate();
      return bTime.compareTo(aTime);
    });

    final targetDoc = futureDocs.first;
    final data = targetDoc.data();

    return NotificationModel(
      id: targetDoc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      image: data['image'],
      onTapLink: data['onTapLink'],
    );
  }
}
