import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';
import 'package:arjun_guruji/features/Admin/domain/repository/event_repository.dart';
import 'dart:io';

class CreateEventUseCase {
  final EventRepository repository;
  CreateEventUseCase(this.repository);

  Future<Event> call(Event event, {File? image}) {
    return repository.createEvent(event, image: image);
  }
} 