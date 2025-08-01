import '../entity/notification.dart';
import '../repository/notification_repository.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'dart:io';
import 'package:dartz/dartz.dart';

class CreateNotificationParams {
  final NotificationEntity notification;
  final File? image;
  CreateNotificationParams(this.notification, {this.image});
}

class CreateNotificationUseCase
    implements Usecase<void, CreateNotificationParams, String> {
  final NotificationRepository repository;
  CreateNotificationUseCase(this.repository);

  @override
  Future<Either<String, void>> call(CreateNotificationParams params) async {
    try {
      await repository.createNotification(params.notification,
          image: params.image);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}
