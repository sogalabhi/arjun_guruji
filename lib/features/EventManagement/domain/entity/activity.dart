class ActivityEntity {
  final String time; // "Morning" or "Evening"
  final String activity; // e.g., "Homa", "Bhajans"
  final String venue; // e.g., "Ashrama, Mysuru"

  ActivityEntity({
    required this.time,
    required this.activity,
    required this.venue,
  });
}
