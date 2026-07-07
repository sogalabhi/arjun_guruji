import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import '../../domain/usecases/fetch_notifications_usecase.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FetchNotificationsUseCase fetchNotificationsUseCase;

  NotificationBloc(this.fetchNotificationsUseCase)
      : super(NotificationInitial()) {
    on<FetchNotifications>((event, emit) async {
      emit(NotificationLoading());
      final result = await fetchNotificationsUseCase(NoParams());
      result.fold(
        (failure) => emit(NotificationError(failure)),
        (notifications) => emit(NotificationLoaded(notifications)),
      );
    });
  }
}
