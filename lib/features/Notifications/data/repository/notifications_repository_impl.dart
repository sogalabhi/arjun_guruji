import 'package:dartz/dartz.dart';
import '../../domain/notification.dart';
import '../../domain/repository/notifications_repository.dart';
import '../datasource/notifications_remote_ds.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;

  NotificationsRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, List<NotificationEntity>>> fetchNotifications() async {
    try {
      final models = await remoteDataSource.fetchNotifications();
      final entities = models.map((model) => model.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left('Failed to fetch notifications: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, NotificationEntity?>> fetchLatestNotification() async {
    try {
      final model = await remoteDataSource.fetchLatestNotification();
      if (model == null) return const Right(null);
      return Right(model.toEntity());
    } catch (e) {
      return Left('Failed to fetch latest notification: ${e.toString()}');
    }
  }
}
