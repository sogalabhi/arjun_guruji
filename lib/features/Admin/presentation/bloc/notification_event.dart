import 'package:equatable/equatable.dart';
import '../../domain/usecases/create_notification_usecase.dart';
import '../../domain/usecases/update_notification_usecase.dart';
import '../../domain/usecases/upload_notification_image_usecase.dart';

abstract class NotificationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class CreateNotification extends NotificationEvent {
  final CreateNotificationParams params;
  CreateNotification(this.params);
  @override
  List<Object?> get props => [params];
}

class UpdateNotification extends NotificationEvent {
  final UpdateNotificationParams params;
  UpdateNotification(this.params);
  @override
  List<Object?> get props => [params];
}

class DeleteNotification extends NotificationEvent {
  final String notificationId;
  DeleteNotification(this.notificationId);
  @override
  List<Object?> get props => [notificationId];
}

class UploadNotificationImage extends NotificationEvent {
  final UploadNotificationImageParams params;
  UploadNotificationImage(this.params);
  @override
  List<Object?> get props => [params];
}
