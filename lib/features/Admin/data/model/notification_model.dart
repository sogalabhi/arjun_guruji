import '../../domain/entity/notification.dart';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String? image;
  final bool isVisible;
  final String? onTapLink;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.image,
    required this.isVisible,
    this.onTapLink,
  });

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    DateTime parseDate(dynamic value) {
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      if (value != null && value.toString().contains('Timestamp')) {
        // Firestore Timestamp
        return (value as dynamic).toDate();
      }
      throw Exception('Invalid date value: $value');
    }

    return NotificationModel(
      id: map['id'] as String? ?? '',
      title: map['title'] as String? ?? '',
      description: map['description'] as String? ?? '',
      dateTime: parseDate(map['dateTime']),
      image: map['image'] as String?,
      isVisible: map['isVisible'] ?? true,
      onTapLink: map['onTapLink'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dateTime': dateTime.toIso8601String(),
      'image': image,
      'isVisible': isVisible,
      'onTapLink': onTapLink,
    };
  }

  static NotificationModel fromEntity(NotificationEntity entity) {
    return NotificationModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dateTime: entity.dateTime,
      image: entity.image,
      isVisible: entity.isVisible,
      onTapLink: entity.onTapLink,
    );
  }

  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      description: description,
      dateTime: dateTime,
      image: image,
      isVisible: isVisible,
      onTapLink: onTapLink,
    );
  }
}
