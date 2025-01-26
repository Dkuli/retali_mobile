

import 'package:retali/pilgrim.dart';
import 'package:retali/schedule.dart';


class Group {
  final int id;
  final String name;
  final List<Pilgrim> pilgrims;
  final List<Schedule> schedules;

  Group({
    required this.id,
    required this.name,
    required this.pilgrims,
    required this.schedules,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id'],
      name: json['name'],
      pilgrims: (json['pilgrims'] as List)
          .map((p) => Pilgrim.fromJson(p))
          .toList(),
      schedules: (json['schedules'] as List)
          .map((s) => Schedule.fromJson(s))
          .toList(),
    );
  }
}