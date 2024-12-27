
// lib/models/schedule.dart
import 'package:retali/models/activity.dart';

class Schedule {
  final int id;
  final DateTime date;
  final List<Activity> activities;

  Schedule({
    required this.id,
    required this.date,
    required this.activities,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      date: DateTime.parse(json['date']),
      activities: (json['activities'] as List)
          .map((a) => Activity.fromJson(a))
          .toList(),
    );
  }
}