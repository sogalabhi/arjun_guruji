import 'package:arjun_guruji/features/EventManagement/data/model/activities_model.dart';
import 'package:arjun_guruji/features/EventManagement/data/model/organiser_model.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel extends EventEntity {
  EventModel({
    required super.title,
    required super.eventType,
    required super.startDate,
    required super.endDate,
    required super.venue,
    required super.city,
    required super.place,
    super.guest,
    super.frequency,
    super.day,
    super.activities,
    required super.description,
    required super.interestedCount,
    required super.galleryLinks,
    required super.status,
    super.organizerInfo,
    super.tags,
    super.rsvp = false,
    super.rsvpCount = 0,
  });

  factory EventModel.fromFirestore(Map<String, dynamic> doc) {
    return EventModel(
      title: doc['title'] ?? '',
      eventType: doc['eventType'] ?? '',
      startDate: (doc['startDate'] as Timestamp).toDate(),
      endDate: (doc['endDate'] as Timestamp).toDate(),
      venue: doc['venue'] ?? '',
      city: doc['city'] ?? '',
      place: doc['place'] ?? '',
      guest: doc['guest'],
      frequency: doc['frequency'],
      day: doc['day'],
      activities: doc['activities'] != null
          ? (doc['activities'] as List)
              .map((activity) => ActivityModel.fromMap(activity))
              .toList()
          : null,
      description: doc['description'] ?? '',
      interestedCount: doc['interestedCount'] ?? 0,
      galleryLinks: List<String>.from(doc['galleryLinks'] ?? []),
      status: doc['status'] ?? 'Upcoming',
      organizerInfo: doc['organizerInfo'] != null
          ? OrganizerInfoModel.fromMap(doc['organizerInfo'])
          : null,
      tags: doc['tags'] != null ? List<String>.from(doc['tags']) : null,
      rsvp: doc['rsvp'] ?? false,
      rsvpCount: doc['rsvpCount'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'eventType': eventType,
      'startDate': Timestamp.fromDate(startDate),
      'endDate': Timestamp.fromDate(endDate),
      'venue': venue,
      'city': city,
      'place': place,
      'guest': guest,
      'frequency': frequency,
      'day': day,
      'activities': activities?.map((activity) => (activity as ActivityModel).toMap()).toList(),
      'description': description,
      'interestedCount': interestedCount,
      'galleryLinks': galleryLinks,
      'status': status,
      'organizerInfo': organizerInfo != null ? (organizerInfo as OrganizerInfoModel).toMap() : null,
      'tags': tags,
      'rsvp': rsvp,
      'rsvpCount': rsvpCount ?? 0, // Ensure a default value if null
    };
  }
}
