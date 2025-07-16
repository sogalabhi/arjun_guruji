import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';
import 'package:arjun_guruji/features/Admin/domain/repository/event_repository.dart';

class GetEventsUseCase {
  final EventRepository repository;
  GetEventsUseCase(this.repository);

  Future<List<Event>> call() {
    return repository.getAllEvents();
  }
} 