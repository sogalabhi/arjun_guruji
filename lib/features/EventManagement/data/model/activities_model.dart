import 'package:arjun_guruji/features/EventManagement/domain/entity/activity.dart';

class ActivityModel extends ActivityEntity {
  ActivityModel({
    required super.time,
    required super.activity,
    required super.venue,
  });

  factory ActivityModel.fromMap(Map<String, dynamic> map) {
    return ActivityModel(
      time: map['time'] ?? '',
      activity: map['activity'] ?? '',
      venue: map['venue'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'time': time,
      'activity': activity,
      'venue': venue,
    };
  }
}
