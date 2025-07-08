import 'package:arjun_guruji/features/EventManagement/data/datasource/events_remote_datastructure.dart';
import 'package:arjun_guruji/features/EventManagement/data/model/events_model.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:arjun_guruji/features/EventManagement/domain/repository/events_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:hive/hive.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventRemoteDataSource remoteDataSource;

  const EventsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<String, List<EventEntity>>> getAllEvents() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final eventsBox = await Hive.openBox<EventModel>('eventsBox');
      if (connectivityResult != ConnectivityResult.none) {
        // Online: fetch from Firestore and update Hive
        final events = await remoteDataSource.getAllEvents();
        await eventsBox.clear();
        await eventsBox.addAll(events);
        if (events.isEmpty) {
          return const Left('No events found');
        }
        return Right(events);
      } else {
        // Offline: fetch from Hive
        final events = eventsBox.values.toList();
        if (events.isEmpty) {
          return const Left('No events found (offline)');
        }
        return Right(events);
      }
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