import '../notification.dart';
import '../../data/repository/notifications_repository_impl.dart';

class FetchNotificationsUseCase {
  final NotificationsRepositoryImpl repository;
  FetchNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call() async {
    return await repository.fetchNotifications();
  }
}
