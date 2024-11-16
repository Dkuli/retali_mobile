class NotificationModel {
  final String id;
  final String title;
  final String message;
  final DateTime time;
  final bool isRead;
  final String? image;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    this.isRead = false,
    this.image,
  });
}
