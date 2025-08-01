class NotificationModel {
  final String title;
  final String description;
  final DateTime dateTime;
  final String? image;
  final String? onTapLink;

  NotificationModel({
    required this.title,
    required this.description,
    required this.dateTime,
    this.image,
    this.onTapLink,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'],
      description: json['description'],
      dateTime: DateTime.parse(json['dateTime']),
      image: json['image'],
      onTapLink: json['onTapLink'],
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'dateTime': dateTime.toIso8601String(),
        'image': image,
        'onTapLink': onTapLink,
      };
}
