// lib/models/activity.dart
class Activity {
  final int id;
  final int groupScheduleId;
  final DateTime time;
  final String title;
  final String? description;
  final String location;
  final String category;

  Activity({
    required this.id,
    required this.groupScheduleId,
    required this.time,
    required this.title,
    this.description,
    required this.location,
    required this.category,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      groupScheduleId: json['group_schedule_id'],
      time: DateTime.parse(json['time']),
      title: json['title'],
      description: json['description'],
      location: json['location'],
      category: json['category'],
    );
  }
}