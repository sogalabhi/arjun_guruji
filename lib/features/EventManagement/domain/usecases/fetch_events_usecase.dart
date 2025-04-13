import 'package:arjun_guruji/core/usecases/usecase.dart';
import 'package:arjun_guruji/features/EventManagement/data/model/events_model.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:arjun_guruji/features/EventManagement/domain/repository/events_repository.dart';
import 'package:dartz/dartz.dart';

class FetchEventsUseCase implements Usecase<List<EventEntity>, NoParams, String> {
  final EventsRepository eventsRepository;

  FetchEventsUseCase(this.eventsRepository);

  @override
  Future<Either<String, List<EventEntity>>> call(NoParams params) async {
    var res = await eventsRepository.getAllEvents();
    return res;
  }
}

class UpdateInterestedCountUseCase
    implements Usecase<void, UpdateInterestedCountParams, String> {
  final EventsRepository eventsRepository;

  UpdateInterestedCountUseCase(this.eventsRepository);

  @override
  Future<Either<String, void>> call(UpdateInterestedCountParams params) async {
    var res = await eventsRepository.updateInterestedCount(
      eventId: params.eventId,
      increment: params.increment,
    );
    return res;
  }
}

class UpdateInterestedCountParams {
  final String eventId;
  final bool increment;

  UpdateInterestedCountParams({required this.eventId, required this.increment});
}
