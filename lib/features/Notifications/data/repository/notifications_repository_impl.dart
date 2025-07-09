import '../../domain/notification.dart';
import '../datasource/notifications_remote_ds.dart';

class NotificationsRepositoryImpl {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl(this.remoteDataSource);

  Future<List<NotificationEntity>> fetchNotifications() async {
    final models = await remoteDataSource.fetchNotifications();
    return models.map((model) => NotificationEntity(
      title: model.title,
      description: model.description,
      dateTime: model.dateTime,
      image: model.image,
      onTapLink: model.onTapLink,
    )).toList();
  }
} 