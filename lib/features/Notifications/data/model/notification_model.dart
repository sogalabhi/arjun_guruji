import '../../domain/notification.dart';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String? image;
  final String? onTapLink;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.image,
    this.onTapLink,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json, String documentId) {
    return NotificationModel(
      id: documentId,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
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

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      description: description,
      dateTime: dateTime,
      image: image,
      onTapLink: onTapLink,
    );
  }
}
