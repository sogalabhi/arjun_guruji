class NotificationEntity {
  final String title;
  final String description;
  final DateTime dateTime;
  final String? image;
  final String? onTapLink;

  NotificationEntity({
    required this.title,
    required this.description,
    required this.dateTime,
    this.image,
    this.onTapLink,
  });
}
