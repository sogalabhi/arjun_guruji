class EventModel {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String venue;
  final List<String> galleryLinks;
  final int interestedCount;
  final String eventType;
  final bool isFeatured;
  final String city;
  final String status;

  EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.venue,
    required this.galleryLinks,
    required this.interestedCount,
    this.eventType = "Simple",
    this.isFeatured = true,
    this.city = "",
    this.status = "Upcoming",
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      if (value != null && value.toString().contains('Timestamp')) {
        // Firestore Timestamp
        return (value as dynamic).toDate();
      }
      throw Exception('Invalid date value: $value');
    }

    return EventModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      startDate: parseDate(map['startDate']),
      endDate: parseDate(map['endDate']),
      venue: map['venue'] as String? ?? '',
      galleryLinks: List<String>.from(map['galleryLinks'] ?? []),
      interestedCount: map['interestedCount'] ?? 0,
      eventType: map['eventType'] as String? ?? 'Simple',
      isFeatured: map['isFeatured'] ?? true,
      city: map['city'] as String? ?? '',
      status: map['status'] as String? ?? 'Upcoming',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate,
      'endDate': endDate,
      'venue': venue,
      'galleryLinks': galleryLinks,
      'interestedCount': interestedCount,
      'eventType': eventType,
      'isFeatured': isFeatured,
      'city': city,
      'status': status,
    };
  }
}
