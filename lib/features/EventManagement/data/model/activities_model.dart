import 'package:arjun_guruji/features/EventManagement/domain/entity/activity.dart';
import 'package:hive/hive.dart';

part 'activities_model.g.dart';

@HiveType(typeId: 20)
class ActivityModel extends ActivityEntity {
  @HiveField(0)
  final String time;
  @HiveField(1)
  final String activity;
  @HiveField(2)
  final String venue;

  ActivityModel({
    required this.time,
    required this.activity,
    required this.venue,
  }) : super(time: time, activity: activity, venue: venue);

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
