import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';
import 'package:arjun_guruji/features/Admin/domain/repository/event_repository.dart';
import 'dart:io';

class UpdateEventUseCase {
  final EventRepository repository;
  UpdateEventUseCase(this.repository);

  Future<void> call(Event event, {File? image}) {
    return repository.updateEvent(event, image: image);
  }
} 