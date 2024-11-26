
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

  factory GuideCategory.fromJson(Map<String, dynamic> json) {
    return GuideCategory(
      title: json['title'],
      icon: IconData(json['icon'], fontFamily: 'MaterialIcons'),
      color: Color(json['color']),
      guides: (json['guides'] as List)
          .map((guide) => Guide.fromJson(guide))
          .toList(),
    );
  }
}

class Guide {
  final String title;
  final String description;
  final String imageUrl;
  final String content;

  Guide({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.content,
  });

  factory Guide.fromJson(Map<String, dynamic> json) {
    return Guide(
      title: json['title'],
      description: json['description'],
      imageUrl: json['image_url'],
      content: json['content'],
    );
  }
}
