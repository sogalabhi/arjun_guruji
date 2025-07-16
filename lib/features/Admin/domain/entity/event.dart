class Event {
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
  final String place;
  final String status;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.venue,
    required this.galleryLinks,
    required this.interestedCount,
    this.eventType = "One-time",
    this.isFeatured = false,
    this.city = "",
    this.place = "",
    this.status = "Upcoming",
  });
} 