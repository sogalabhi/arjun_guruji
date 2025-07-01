
class NotificationEntity {
  final String title;
  final String description;
  final DateTime dateTime;
  final String? onTapLink;

  NotificationEntity({
    required this.title,
    required this.description,
    required this.dateTime,
    this.onTapLink,
  });
}