import 'package:arjun_guruji/features/EventManagement/data/model/events_model.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:arjun_guruji/features/EventManagement/domain/repository/events_repository.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:arjun_guruji/features/EventManagement/data/repository/events_repository_impl.dart';
import 'package:arjun_guruji/features/EventManagement/data/datasource/events_remote_datastructure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'event_event.dart';
part 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {
  final EventsRepository repository;

  EventBloc({EventsRepository? repo})
      : repository = repo ?? EventsRepositoryImpl(remoteDataSource: EventRemoteDataSourceImpl(FirebaseFirestore.instance)),
        super(EventsLoading()) {
    on<CheckInterestedStatus>((event, emit) async {
      emit(EventsLoading());
      final result = await repository.getAllEvents();
      result.fold(
        (failure) => emit(EventsError(failure)),
        (events) {
          final found = events.firstWhere(
            (e) => e.id == event.eventId,
            orElse: () => EventModel(
              id: '',
              title: '',
              eventType: '',
              startDate: DateTime.now(),
              endDate: DateTime.now(),
              venue: '',
              city: '',
              place: '',
              description: '',
              interestedCount: 0,
              galleryLinks: [],
              status: '',
              isFeatured: false,
            ),
          );
          if (found.id.isNotEmpty) {
            emit(InterestedCountState(count: found.interestedCount));
          } else {
            emit(EventsError('Event not found'));
          }
        },
      );
    });
    on<ToggleInterested>((event, emit) async {
      emit(EventsLoading());
      await repository.updateInterestedCount(eventId: event.eventId, increment: event.increment);
      // Fetch updated count
      final result = await repository.getAllEvents();
      result.fold(
        (failure) => emit(EventsError(failure)),
        (events) {
          final found = events.firstWhere(
            (e) => e.id == event.eventId,
            orElse: () => EventModel(
              id: '',
              title: '',
              eventType: '',
              startDate: DateTime.now(),
              endDate: DateTime.now(),
              venue: '',
              city: '',
              place: '',
              description: '',
              interestedCount: 0,
              galleryLinks: [],
              status: '',
              isFeatured: false,
            ),
          );
          if (found.id.isNotEmpty) {
            emit(InterestedCountState(count: found.interestedCount));
          } else {
            emit(EventsError('Event not found'));
          }
        },
      );
    });
    on<FetchEvents>((event, emit) async {
      emit(EventsLoading());
      final result = await repository.getAllEvents();
      result.fold(
        (failure) => emit(EventsError(failure)),
        (events) {
          for (final e in events) {
            print('[EVENT] id: ${e.id}, title: ${e.title}, type: ${e.eventType}, start: ${e.startDate}, end: ${e.endDate}');
          }
          emit(EventsLoaded(events));
        },
      );
    });
  }
} 