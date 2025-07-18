import '../../domain/repository/notification_repository.dart';
import '../datasource/notification_remote_datasource.dart';
import '../model/notification_model.dart';
import '../../domain/entity/notification.dart';
import 'dart:io';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;
  NotificationRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<NotificationEntity>> getAllNotifications() async {
    final models = await remoteDataSource.getAllNotifications();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> createNotification(NotificationEntity notification, {File? image}) async {
    final model = NotificationModel.fromEntity(notification);
    await remoteDataSource.createNotification(model, image: image);
  }

  @override
  Future<void> updateNotification(NotificationEntity notification, {File? image}) async {
    final model = NotificationModel.fromEntity(notification);
    await remoteDataSource.updateNotification(model, image: image);
  }

  @override
  Future<void> deleteNotification(String notificationId) async {
    await remoteDataSource.deleteNotification(notificationId);
  }

  @override
  Future<String> uploadImage(File imageFile, String notificationId) async {
    return await remoteDataSource.uploadImage(imageFile, notificationId);
  }
} 