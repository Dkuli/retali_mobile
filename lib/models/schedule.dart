// lib/models/schedule.dart
import 'package:retali/models/activity.dart';

class Schedule {
  final int id;
  final DateTime date;
  final String dayTitle;
  final String description;
  final List<Activity> activities;

  Schedule({
    required this.id,
    required this.date,
    required this.dayTitle,
    required this.description,
    required this.activities,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      date: DateTime.parse(json['date']),
      dayTitle: json['day_title'],
      description: json['description'],
      activities: (json['activities'] as List)
          .map((a) => Activity.fromJson(a))
          .toList(),
    );
  }
}