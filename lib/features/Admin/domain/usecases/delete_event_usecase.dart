import 'package:arjun_guruji/features/Admin/domain/repository/event_repository.dart';

class DeleteEventUseCase {
  final EventRepository repository;
  DeleteEventUseCase(this.repository);

  Future<void> call(String eventId) {
    return repository.deleteEvent(eventId);
  }
} 