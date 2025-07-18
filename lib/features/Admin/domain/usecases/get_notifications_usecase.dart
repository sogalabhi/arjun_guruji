import '../entity/notification.dart';
import '../repository/notification_repository.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class GetNotificationsUseCase implements Usecase<List<NotificationEntity>, NoParams, String> {
  final NotificationRepository repository;
  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<String, List<NotificationEntity>>> call(NoParams params) async {
    try {
      final notifications = await repository.getAllNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(e.toString());
    }
  }
} 