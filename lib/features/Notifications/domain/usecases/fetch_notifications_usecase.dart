import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';
import '../notification.dart';
import '../repository/notifications_repository.dart';

class FetchNotificationsUseCase implements Usecase<List<NotificationEntity>, NoParams, String> {
  final NotificationsRepository repository;
  FetchNotificationsUseCase(this.repository);

  @override
  Future<Either<String, List<NotificationEntity>>> call(NoParams params) async {
    return await repository.fetchNotifications();
  }
}
