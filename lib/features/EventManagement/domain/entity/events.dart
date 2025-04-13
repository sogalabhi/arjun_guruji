import 'package:arjun_guruji/features/EventManagement/domain/entity/activity.dart';
import 'package:arjun_guruji/features/EventManagement/domain/entity/organiser.dart';

class EventEntity {
  String title;
  String eventType;
  DateTime startDate;
  DateTime endDate;
  String venue;
  String city;
  String place;
  String? guest;
  String? frequency;
  String? day;
  List<ActivityEntity>? activities;
  String description; // Event details/description
  int interestedCount; // Number of users marked interested
  List<String> galleryLinks; // Array of links to images/videos
  String status; // Event status ("Upcoming", "Completed", "Cancelled", etc.)
  OrganizerInfoEntity? organizerInfo; // Organizer details for Non-Trust events
  List<String>? tags; // Event tags (Spiritual, Cultural, etc.)
  bool rsvp; // Whether registration or RSVP is required
  int? rsvpCount; // Count of people who have RSVPed

  EventEntity({
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
    this.organizerInfo,
    this.tags,
    this.rsvp = false,
    this.rsvpCount,
  });
}
