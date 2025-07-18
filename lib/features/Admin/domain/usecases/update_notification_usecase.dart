import '../entity/notification.dart';
import '../repository/notification_repository.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'dart:io';
import 'package:dartz/dartz.dart';

class UpdateNotificationParams {
  final NotificationEntity notification;
  final File? image;
  UpdateNotificationParams(this.notification, {this.image});
}

class UpdateNotificationUseCase implements Usecase<void, UpdateNotificationParams, String> {
  final NotificationRepository repository;
  UpdateNotificationUseCase(this.repository);

  @override
  Future<Either<String, void>> call(UpdateNotificationParams params) async {
    try {
      await repository.updateNotification(params.notification, image: params.image);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
} 