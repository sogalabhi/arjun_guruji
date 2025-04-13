import 'package:arjun_guruji/features/EventManagement/data/model/events_model.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';

import 'package:dartz/dartz.dart';

abstract class EventsRepository {
  Future<Either<String, List<EventEntity>>> getAllEvents();
  Future<Either<String, void>> updateInterestedCount(
      {required String eventId, required bool increment});
}
