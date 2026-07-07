import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../notification.dart';
import '../repository/notifications_repository.dart';

class FetchLatestNotificationUseCase implements Usecase<NotificationEntity?, NoParams, String> {
  final NotificationsRepository repository;
  FetchLatestNotificationUseCase(this.repository);

  @override
  Future<Either<String, NotificationEntity?>> call(NoParams params) async {
    return await repository.fetchLatestNotification();
  }
}
