import 'package:equatable/equatable.dart';
import '../../domain/entity/notification.dart';

abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  NotificationLoaded(this.notifications);
  @override
  List<Object?> get props => [notifications];
}

class NotificationError extends NotificationState {
  final String message;
  NotificationError(this.message);
  @override
  List<Object?> get props => [message];
}

class NotificationOperationSuccess extends NotificationState {
  final String message;
  NotificationOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}
