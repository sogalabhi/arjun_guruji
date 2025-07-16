import 'package:arjun_guruji/features/Admin/domain/entity/event.dart';
import 'dart:io';

abstract class EventRepository {
  Future<List<Event>> getAllEvents();
  Future<Event> createEvent(Event event, {File? image});
  Future<void> updateEvent(Event event, {File? image});
  Future<void> deleteEvent(String eventId);
  Future<String> uploadImage(File imageFile);
} 