import 'package:arjun_guruji/features/Admin/domain/repository/event_repository.dart';
import 'package:arjun_guruji/features/Admin/data/datasource/event_remote_datasource.dart';
import 'package:arjun_guruji/features/Admin/data/model/event_model.dart';
import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';
import 'dart:io';

class EventRepositoryImpl implements EventRepository {
  final EventRemoteDataSource remoteDataSource;
  EventRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Event>> getAllEvents() async {
    final models = await remoteDataSource.getAllEvents();
    return models
        .map((m) => Event(
              id: m.id,
              title: m.title,
              description: m.description,
              startDate: m.startDate,
              endDate: m.endDate,
              venue: m.venue,
              galleryLinks: m.galleryLinks,
              interestedCount: m.interestedCount,
            ))
        .toList();
  }

  @override
  Future<Event> createEvent(Event event, {File? image}) async {
    final model = EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      startDate: event.startDate,
      endDate: event.endDate,
      venue: event.venue,
      galleryLinks: event.galleryLinks,
      interestedCount: event.interestedCount,
    );
    final created = await remoteDataSource.createEvent(model, image: image);
    return Event(
      id: created.id,
      title: created.title,
      description: created.description,
      startDate: created.startDate,
      endDate: created.endDate,
      venue: created.venue,
      galleryLinks: created.galleryLinks,
      interestedCount: created.interestedCount,
    );
  }

  @override
  Future<void> updateEvent(Event event, {File? image}) async {
    final model = EventModel(
      id: event.id,
      title: event.title,
      description: event.description,
      startDate: event.startDate,
      endDate: event.endDate,
      venue: event.venue,
      galleryLinks: event.galleryLinks,
      interestedCount: event.interestedCount,
    );
    await remoteDataSource.updateEvent(model, image: image);
  }

  @override
  Future<void> deleteEvent(String eventId) async {
    await remoteDataSource.deleteEvent(eventId);
  }

  @override
  Future<String> uploadImage(File imageFile) async {
    return await remoteDataSource.uploadImage(imageFile);
  }

  @override
  Future<String> uploadImageToEventFolder(
      File imageFile, String eventName) async {
    return await remoteDataSource.uploadImageToEventFolder(
        imageFile, eventName);
  }
}
