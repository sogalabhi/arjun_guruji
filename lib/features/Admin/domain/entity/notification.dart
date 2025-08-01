class NotificationEntity {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String? image;
  final bool isVisible;
  final String? onTapLink;

  NotificationEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.image,
    required this.isVisible,
    this.onTapLink,
  });
}
