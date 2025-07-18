import '../repository/notification_repository.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'dart:io';
import 'package:dartz/dartz.dart';

class UploadNotificationImageParams {
  final File image;
  final String notificationId;
  UploadNotificationImageParams(this.image, this.notificationId);
}

class UploadNotificationImageUseCase implements Usecase<String, UploadNotificationImageParams, String> {
  final NotificationRepository repository;
  UploadNotificationImageUseCase(this.repository);

  @override
  Future<Either<String, String>> call(UploadNotificationImageParams params) async {
    try {
      final url = await repository.uploadImage(params.image, params.notificationId);
      return Right(url);
    } catch (e) {
      return Left(e.toString());
    }
  }
} 