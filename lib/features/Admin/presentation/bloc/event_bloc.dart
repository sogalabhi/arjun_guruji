import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/get_events_usecase.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/create_event_usecase.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/update_event_usecase.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/delete_event_usecase.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final GetEventsUseCase getEvents;
  final CreateEventUseCase createEvent;
  final UpdateEventUseCase updateEvent;
  final DeleteEventUseCase deleteEvent;

  EventBloc({
    required this.getEvents,
    required this.createEvent,
    required this.updateEvent,
    required this.deleteEvent,
  }) : super(EventInitial()) {
    on<LoadEvents>((event, emit) async {
      emit(EventLoading());
      try {
        final events = await getEvents();
        emit(EventLoaded(events));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });
    on<CreateEvent>((event, emit) async {
      emit(EventOperationLoading());
      try {
        await createEvent(event.event);
        add(LoadEvents());
        emit(EventOperationSuccess('Event created successfully'));
      } catch (e) {
        emit(EventError(e.toString()));
      }
    });
    on<UpdateEvent>((event, emit) async {
      emit(EventOperationLoading());
      try {
        await updateEvent(event.event);
        add(LoadEvents());
        emit(EventOperationSuccess('Event updated successfully'));
      } catch (e) {
        emit(EventError(e.toString()));
      }
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
  }
} 