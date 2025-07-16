import 'package:equatable/equatable.dart';
import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';

abstract class EventState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}
class EventLoading extends EventState {}
class EventLoaded extends EventState {
  final List<Event> events;
  EventLoaded(this.events);
  @override
  List<Object?> get props => [events];
}
class EventError extends EventState {
  final String message;
  EventError(this.message);
  @override
  List<Object?> get props => [message];
}
class EventOperationLoading extends EventState {}
class EventOperationSuccess extends EventState {
  final String message;
  EventOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
} 