import 'package:equatable/equatable.dart';
import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';

abstract class EventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventEvent {}

class CreateEvent extends EventEvent {
  final Event event;
  CreateEvent(this.event);
  @override
  List<Object?> get props => [event];
}

class UpdateEvent extends EventEvent {
  final Event event;
  UpdateEvent(this.event);
  @override
  List<Object?> get props => [event];
}

class DeleteEvent extends EventEvent {
  final String eventId;
  DeleteEvent(this.eventId);
  @override
  List<Object?> get props => [eventId];
} 