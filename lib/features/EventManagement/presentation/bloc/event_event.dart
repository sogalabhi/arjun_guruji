part of 'event_bloc.dart';

abstract class EventEvent extends Equatable {
  const EventEvent();
  @override
  List<Object?> get props => [];
}

class CheckInterestedStatus extends EventEvent {
  final String eventId;
  const CheckInterestedStatus(this.eventId);
  @override
  List<Object?> get props => [eventId];
}

class ToggleInterested extends EventEvent {
  final String eventId;
  final bool increment;
  const ToggleInterested(this.eventId, this.increment);
  @override
  List<Object?> get props => [eventId, increment];
}

class FetchEvents extends EventEvent {}
