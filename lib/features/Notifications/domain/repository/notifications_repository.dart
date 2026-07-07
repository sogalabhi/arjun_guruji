import 'package:dartz/dartz.dart';
import '../notification.dart';

abstract class NotificationsRepository {
  Future<Either<String, List<NotificationEntity>>> fetchNotifications();
  Future<Either<String, NotificationEntity?>> fetchLatestNotification();
}
