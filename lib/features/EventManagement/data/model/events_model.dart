import 'package:arjun_guruji/features/EventManagement/data/model/activities_model.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/events.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

part 'events_model.g.dart';

@HiveType(typeId: 21)
@HiveType(typeId: 21)
class EventModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String eventType;

  @HiveField(3)
  final DateTime startDate;

  @HiveField(4)
  final DateTime endDate;

  @HiveField(5)
  final String venue;

  @HiveField(6)
  final String city;

  @HiveField(7)
  final String place;

  @HiveField(8)
  final String? guest;

  @HiveField(9)
  final String? frequency;

  @HiveField(10)
  final String? day;

  @HiveField(11)
  final List<ActivityModel>? activities;

  @HiveField(12)
  final String description;

  @HiveField(13)
  final int interestedCount;

  @HiveField(14)
  final List<String> galleryLinks;

  @HiveField(15)
  final String status;

  @HiveField(16)
  final bool isFeatured;

  @HiveField(19)
  final List<String>? tags;

  @HiveField(20)
  final DateTime? lastUpdated;

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
    this.lastUpdated,
  });

  factory EventModel.fromFirestore(String id, Map<String, dynamic> doc) {
    DateTime parseDate(dynamic value) {
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      if (value is Timestamp) return value.toDate();
      throw Exception('Invalid date value: $value');
    }

    final rawLastUpdated = doc['lastUpdated'];

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
      lastUpdated: rawLastUpdated is Timestamp ? rawLastUpdated.toDate() : null,
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
      'lastUpdated': lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
    };
  }

  static EventModel fromEntity(EventEntity entity) {
    return EventModel(
      id: entity.id,
      title: entity.title,
      eventType: entity.eventType,
      startDate: entity.startDate,
      endDate: entity.endDate,
      venue: entity.venue,
      city: entity.city,
      place: entity.place,
      guest: entity.guest,
      frequency: entity.frequency,
      day: entity.day,
      activities: entity.activities?.map((a) => ActivityModel.fromEntity(a)).toList(),
      description: entity.description,
      interestedCount: entity.interestedCount,
      galleryLinks: entity.galleryLinks,
      status: entity.status,
      tags: entity.tags,
      isFeatured: entity.isFeatured,
      lastUpdated: entity.lastUpdated,
    );
  }

  static EventEntity toEntity(EventModel model) {
    return EventEntity(
      id: model.id,
      title: model.title,
      eventType: model.eventType,
      startDate: model.startDate,
      endDate: model.endDate,
      venue: model.venue,
      city: model.city,
      place: model.place,
      guest: model.guest,
      frequency: model.frequency,
      day: model.day,
      activities: model.activities?.map((a) => ActivityModel.toEntity(a)).toList(),
      description: model.description,
      interestedCount: model.interestedCount,
      galleryLinks: model.galleryLinks,
      status: model.status,
      tags: model.tags,
      lastUpdated: model.lastUpdated,
    );
  }
}
