import 'package:flutter/material.dart';

class GuideCategory {
  final String title;
  final IconData icon;
  final Color color;
  final List<Guide> guides;

  GuideCategory({
    required this.title,
    required this.icon,
    required this.color,
    required this.guides,
  });
}

class Guide {
  final String title;
  final String description;
  final String content;

  Guide({
    required this.title,
    required this.description,
    required this.content,
  });
}
