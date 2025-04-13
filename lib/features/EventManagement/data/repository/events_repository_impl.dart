import 'package:arjun_guruji/features/EventManagement/data/datasource/events_remote_datastructure.dart';
import 'package:arjun_guruji/features/EventManagement/data/model/events_model.dart';
import 'package:arjun_guruji/features/EventManagement/domain/repository/events_repository.dart';
import 'package:dartz/dartz.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventRemoteDataSource remoteDataSource;

  const EventsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<EventModel>>> getAllEvents() async {
    try {
      final events = await remoteDataSource.getAllEvents();
      if (events.isEmpty) {
        return const Left('No events found');
      }
      return Right(events);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> updateInterestedCount({
    required String eventId,
    required bool increment,
  }) async {
    try {
      await remoteDataSource.updateInterestedCount(
        eventId: eventId,
        increment: increment,
      );
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }
}