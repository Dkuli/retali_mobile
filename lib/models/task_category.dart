
import 'package:flutter/material.dart';
import 'task.dart';

class TaskCategory {
  final String title;
  final IconData icon;
  final List<Task> tasks;
  final Color color;

  TaskCategory({
    required this.title,
    required this.icon,
    required this.tasks,
    required this.color,
  });
}

