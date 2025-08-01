part of 'event_bloc.dart';

abstract class EventState extends Equatable {
  const EventState();
  @override
  List<Object?> get props => [];
}

class InterestedState extends EventState {
  final bool isInterested;
  const InterestedState({required this.isInterested});
  @override
  List<Object?> get props => [isInterested];
}

class InterestedCountState extends EventState {
  final int count;
  const InterestedCountState({required this.count});
  @override
  List<Object?> get props => [count];
}

class EventsLoading extends EventState {}

class EventsLoaded extends EventState {
  final List<EventEntity> events;
  const EventsLoaded(this.events);
  @override
  List<Object?> get props => [events];
}

class EventsError extends EventState {
  final String message;
  const EventsError(this.message);
  @override
  List<Object?> get props => [message];
}
