import '../model/notification_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getAllNotifications();
  Future<void> createNotification(NotificationModel notification,
      {File? image});
  Future<void> updateNotification(NotificationModel notification,
      {File? image});
  Future<void> deleteNotification(String notificationId);
  Future<String> uploadImage(File imageFile, String notificationId);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;
  NotificationRemoteDataSourceImpl(this.firestore, this.storage);

  @override
  Future<List<NotificationModel>> getAllNotifications() async {
    final snapshot = await firestore.collection('Notifications').get();
    return snapshot.docs
        .map((doc) => NotificationModel.fromMap(doc.data()))
        .toList();
  }

  @override
  Future<void> createNotification(NotificationModel notification,
      {File? image}) async {
    String? imageUrl = notification.image;
    if (image != null) {
      imageUrl = await uploadImage(image, notification.title);
    }
    final docRef =
        firestore.collection('Notifications').doc(notification.title);
    final data = notification.toMap();
    data['dateTime'] = Timestamp.fromDate(notification.dateTime);
    await docRef.set({
      ...data,
      'image': imageUrl,
    });
  }

  @override
  Future<void> updateNotification(NotificationModel notification,
      {File? image}) async {
    String? imageUrl = notification.image;
    if (image != null) {
      imageUrl = await uploadImage(image, notification.title);
    }
    final data = notification.toMap();
    data['dateTime'] = Timestamp.fromDate(notification.dateTime);
    await firestore.collection('Notifications').doc(notification.title).update({
      ...data,
      'image': imageUrl,
    });
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await firestore.collection('Notifications').doc(notificationId).delete();
  }

  @override
  Future<String> uploadImage(File imageFile, String notificationId) async {
    final ref = storage.ref().child('notifications/$notificationId.jpg');
    final uploadTask = await ref.putFile(imageFile);
    return await uploadTask.ref.getDownloadURL();
  }
}
