import 'package:equatable/equatable.dart';
import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/create_event_usecase.dart';
import 'package:arjun_guruji/features/Admin/domain/usecases/update_event_usecase.dart';
import 'dart:io';

abstract class EventEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventEvent {}

class CreateEvent extends EventEvent {
  final CreateEventParams params;
  CreateEvent(this.params);
  @override
  List<Object?> get props => [params];
}

class UpdateEvent extends EventEvent {
  final UpdateEventParams params;
  UpdateEvent(this.params);
  @override
  List<Object?> get props => [params];
}

class DeleteEvent extends EventEvent {
  final String eventId;
  DeleteEvent(this.eventId);
  @override
  List<Object?> get props => [eventId];
}

class UploadEventImage extends EventEvent {
  final File image;
  final String eventName;
  UploadEventImage(this.image, this.eventName);
  @override
  List<Object?> get props => [image, eventName];
}
