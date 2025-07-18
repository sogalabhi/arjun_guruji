import '../repository/notification_repository.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:dartz/dartz.dart';

class DeleteNotificationUseCase implements Usecase<void, String, String> {
  final NotificationRepository repository;
  DeleteNotificationUseCase(this.repository);

  @override
  Future<Either<String, void>> call(String notificationId) async {
    try {
      await repository.deleteNotification(notificationId);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
} 