import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/get_events_usecase.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/create_event_usecase.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/update_event_usecase.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/delete_event_usecase.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/upload_event_image_usecase.dart';
import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEventsUseCase getEvents;
  final CreateEventUseCase createEvent;
  final UpdateEventUseCase updateEvent;
  final DeleteEventUseCase deleteEvent;
  final UploadEventImageUseCase uploadEventImage;

  EventBloc({
    required this.getEvents,
    required this.createEvent,
    required this.updateEvent,
    required this.deleteEvent,
    required this.uploadEventImage,
  }) : super(EventInitial()) {
    on<LoadEvents>((event, emit) async {
      emit(EventLoading());
      try {
        final result = await getEvents(NoParams());
        result.fold(
          (failure) => emit(EventError(failure)),
          (events) => emit(EventLoaded(events)),
        );
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });
    on<CreateEvent>((event, emit) async {
      emit(EventOperationLoading());
      final result = await createEvent(event.params);
      result.fold(
        (failure) => emit(EventError(failure)),
        (_) {
          add(LoadEvents());
          emit(EventOperationSuccess('Event created successfully'));
        },
      );
    });
    on<UpdateEvent>((event, emit) async {
      emit(EventOperationLoading());
      final result = await updateEvent(event.params);
      result.fold(
        (failure) => emit(EventError(failure)),
        (_) {
          add(LoadEvents());
          emit(EventOperationSuccess('Event updated successfully'));
        },
      );
    });
    on<DeleteEvent>((event, emit) async {
      emit(EventOperationLoading());
      try {
        await deleteEvent(event.eventId);
        add(LoadEvents());
        emit(EventOperationSuccess('Event deleted successfully'));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });
    on<UploadEventImage>((event, emit) async {
      emit(EventOperationLoading());
      final params = UploadEventImageParams(event.image, event.eventName);
      final result = await uploadEventImage(params);
      result.fold(
        (failure) => emit(EventError(failure)),
        (url) => emit(EventOperationSuccess(url)),
      );
    });
  }
}
