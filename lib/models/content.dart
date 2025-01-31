
import 'package:retali/models/user.dart';

class Content {
  final int id;
  final String title;
  final String description;
  final String type;
  final String fileUrl;
  final DateTime createdAt;
  final User tourLeader;

  Content({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.fileUrl,
    required this.createdAt,
    required this.tourLeader,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      type: json['type'],
      fileUrl: json['file_url'],
      createdAt: DateTime.parse(json['created_at']),
      tourLeader: User.fromJson(json['tour_leader']),
    );
  }
}
