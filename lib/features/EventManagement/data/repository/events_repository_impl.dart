import 'package:arjun_guruji/features/EventManagement/data/datasource/events_remote_datastructure.dart';
import 'package:arjun_guruji/features/EventManagement/data/datasource/events_local_ds.dart';
import 'package:arjun_guruji/features/EventManagement/data/model/events_model.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:arjun_guruji/features/EventManagement/domain/repository/events_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class EventsRepositoryImpl implements EventsRepository {
  final EventRemoteDataSource remoteDataSource;
  final EventsLocalDataSource localDataSource;

  const EventsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<String, List<EventEntity>>> getAllEvents() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      final isOffline = connectivityResult.isEmpty || connectivityResult.first == ConnectivityResult.none;
      final cachedEvents = localDataSource.getCachedEvents();

      if (isOffline) {
        // Offline: fetch from cache
        if (cachedEvents.isEmpty) {
          return const Left('No events found (offline)');
        }
        return Right(cachedEvents.map((model) => EventModel.toEntity(model)).toList());
      }

      // Build cache map for quick lookups
      final existingCache = <String, EventModel>{};
      for (final event in cachedEvents) {
        existingCache[event.id] = event;
      }

      // Fetch remote timestamps from Firestore
      List<Map<String, dynamic>> remoteTimestamps;
      try {
        remoteTimestamps = await remoteDataSource.fetchEventTimestamps();
      } catch (e) {
        // Fallback to cache if remote timestamps fail to load
        if (cachedEvents.isNotEmpty) {
          return Right(cachedEvents.map((model) => EventModel.toEntity(model)).toList());
        }
        return Left('Failed to fetch remote timestamps: $e');
      }

      // Determine if sync is needed (additions, deletions, updates)
      bool needsSync = false;
      final remoteIds = remoteTimestamps.map((m) => m['id'] as String).toSet();

      // Check for deletions
      for (final cachedId in existingCache.keys) {
        if (!remoteIds.contains(cachedId)) {
          needsSync = true;
          break;
        }
      }

      // Check for additions or updates
      if (!needsSync) {
        for (final remoteItem in remoteTimestamps) {
          final id = remoteItem['id'] as String;
          final remoteUpdated = remoteItem['lastUpdated'] as DateTime?;
          final cachedEvent = existingCache[id];

          if (cachedEvent == null) {
            needsSync = true;
            break;
          }

          if (remoteUpdated != null) {
            if (cachedEvent.lastUpdated == null || remoteUpdated.isAfter(cachedEvent.lastUpdated!)) {
              needsSync = true;
              break;
            }
          } else {
            if (cachedEvent.lastUpdated != null) {
              needsSync = true;
              break;
            }
          }
        }
      }

      // Check total count mismatch
      if (!needsSync && cachedEvents.length != remoteTimestamps.length) {
        needsSync = true;
      }

      if (!needsSync) {
        return Right(cachedEvents
            .map((model) => EventModel.toEntity(model))
            .toList());
      }

      final remoteEvents = await remoteDataSource.getAllEvents();
      if (remoteEvents.isEmpty) {
        await localDataSource.clearCache();
        return const Right([]);
      }

      await localDataSource.cacheEvents(remoteEvents);

      return Right(remoteEvents.map((model) => EventModel.toEntity(model)).toList());
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
