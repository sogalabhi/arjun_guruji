import 'dart:io';
import '../entity/notification.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> getAllNotifications();
  Future<void> createNotification(NotificationEntity notification,
      {File? image});
  Future<void> updateNotification(NotificationEntity notification,
      {File? image});
  Future<void> deleteNotification(String notificationId);
  Future<String> uploadImage(File imageFile, String notificationId);
}
