import 'package:arjun_guruji/features/EventManagement/data/model/events_model.dart';
import 'package:hive/hive.dart';

abstract class EventsLocalDataSource {
  List<EventModel> getCachedEvents();
  Future<void> cacheEvents(List<EventModel> list);
  Future<void> clearCache();
}

class EventsLocalDataSourceImpl implements EventsLocalDataSource {
  final Box<EventModel> eventsBox;

  EventsLocalDataSourceImpl({required this.eventsBox});

  @override
  List<EventModel> getCachedEvents() {
    return eventsBox.values.toList();
  }

  @override
  Future<void> cacheEvents(List<EventModel> list) async {
    await eventsBox.clear();
    for (final event in list) {
      await eventsBox.put(event.id, event);
    }
  }

  @override
  Future<void> clearCache() async {
    await eventsBox.clear();
  }
}
