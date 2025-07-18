import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_notifications_usecase.dart';
import '../../domain/usecases/create_notification_usecase.dart';
import '../../domain/usecases/update_notification_usecase.dart';
import '../../domain/usecases/delete_notification_usecase.dart';
import '../../domain/usecases/upload_notification_image_usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final GetNotificationsUseCase getNotifications;
  final CreateNotificationUseCase createNotification;
  final UpdateNotificationUseCase updateNotification;
  final DeleteNotificationUseCase deleteNotification;
  final UploadNotificationImageUseCase uploadNotificationImage;

  NotificationBloc({
    required this.getNotifications,
    required this.createNotification,
    required this.updateNotification,
    required this.deleteNotification,
    required this.uploadNotificationImage,
  }) : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) async {
      emit(NotificationLoading());
      final result = await getNotifications(NoParams());
      result.fold(
        (failure) => emit(NotificationError(failure)),
        (notifications) => emit(NotificationLoaded(notifications)),
      );
    });
    on<CreateNotification>((event, emit) async {
      emit(NotificationLoading());
      final result = await createNotification(event.params);
      result.fold(
        (failure) => emit(NotificationError(failure)),
        (_) {
          add(LoadNotifications());
          emit(NotificationOperationSuccess('Notification created successfully'));
        },
      );
    });
    on<UpdateNotification>((event, emit) async {
      emit(NotificationLoading());
      final result = await updateNotification(event.params);
      result.fold(
        (failure) => emit(NotificationError(failure)),
        (_) {
          add(LoadNotifications());
          emit(NotificationOperationSuccess('Notification updated successfully'));
        },
      );
    });
    on<DeleteNotification>((event, emit) async {
      emit(NotificationLoading());
      final result = await deleteNotification(event.notificationId);
      result.fold(
        (failure) => emit(NotificationError(failure)),
        (_) {
          add(LoadNotifications());
          emit(NotificationOperationSuccess('Notification deleted successfully'));
        },
      );
    });
    on<UploadNotificationImage>((event, emit) async {
      emit(NotificationLoading());
      final result = await uploadNotificationImage(event.params);
      result.fold(
        (failure) => emit(NotificationError(failure)),
        (url) => emit(NotificationOperationSuccess(url)),
      );
    });
  }
} 