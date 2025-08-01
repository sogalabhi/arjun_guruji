import 'package:arjun_guruji/features/EventManagement/data/model/activities_model.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'events_model.g.dart';

@HiveType(typeId: 21)
class EventModel extends EventEntity {
  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String title;
  @override
  @HiveField(2)
  final String eventType;
  @override
  @HiveField(3)
  final DateTime startDate;
  @override
  @HiveField(4)
  final DateTime endDate;
  @override
  @HiveField(5)
  final String venue;
  @override
  @HiveField(6)
  final String city;
  @override
  @HiveField(7)
  final String place;
  @override
  @HiveField(8)
  final String? guest;
  @override
  @HiveField(9)
  final String? frequency;
  @override
  @HiveField(10)
  final String? day;
  @override
  @HiveField(11)
  final List<ActivityModel>? activities;
  @override
  @HiveField(12)
  final String description;
  @override
  @HiveField(13)
  final int interestedCount;
  @override
  @HiveField(14)
  final List<String> galleryLinks;
  @override
  @HiveField(15)
  final String status;
  @override
  @HiveField(16)
  final bool isFeatured;
  @override
  @HiveField(19)
  final List<String>? tags;

  EventModel({
    required this.id,
    required this.title,
    required this.eventType,
    required this.startDate,
    required this.endDate,
    required this.venue,
    required this.city,
    required this.place,
    this.guest,
    this.frequency,
    this.day,
    this.activities,
    required this.description,
    required this.interestedCount,
    required this.galleryLinks,
    required this.status,
    this.tags,
    this.isFeatured = false,
  }) : super(
          id: id,
          title: title,
          eventType: eventType,
          startDate: startDate,
          endDate: endDate,
          venue: venue,
          city: city,
          place: place,
          guest: guest,
          frequency: frequency,
          day: day,
          activities: activities,
          description: description,
          interestedCount: interestedCount,
          galleryLinks: galleryLinks,
          status: status,
          tags: tags,
          isFeatured: isFeatured,
        );

  factory EventModel.fromFirestore(String id, Map<String, dynamic> doc) {
    DateTime parseDate(dynamic value) {
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      if (value is Timestamp) return value.toDate();
      throw Exception('Invalid date value: $value');
    }

    return EventModel(
      id: id,
      title: doc['title'] ?? '',
      eventType: doc['eventType'] ?? '',
      startDate: parseDate(doc['startDate']),
      endDate: parseDate(doc['endDate']),
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
      tags: doc['tags'] != null ? List<String>.from(doc['tags']) : null,
      isFeatured: doc['isFeatured'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
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
      'activities': activities?.map((activity) => (activity).toMap()).toList(),
      'description': description,
      'interestedCount': interestedCount,
      'galleryLinks': galleryLinks,
      'status': status,
      'tags': tags,
      'isFeatured': isFeatured,
    };
  }
}
